%% data analysis code for 1p data
% load imaging data
cd('E:\MATLAB\Imaging Analysis\CNMF-E')
cnmfe_setup
% load the path of your data
animalID = 'RVKC441';
date = '191001';
path = ['G:\Imaging in GC\ImagingData\',animalID,'\',date,'\1'];
cd(path)
file = '03-Oct_21_21_21.mat'; % example data
load(file)
% automatically remove fake neurons
[fakeneuron,neuron_new] = detectfake(neuron);

% view neurons
% i = 1;
% neuron_new.save_neurons(); 

% mannully clear the fake neurons

% neuron_new2 = fakeneuron_manual(neuron_new); % this requires you manully
% delete neurons in a foler; recently I did not use this, I directly used
% the following line of code of doing it.
neuron.viewNeurons([],neuron.C_raw);

% neuron_new.viewNeurons([]); 
neuron.viewNeurons(4,neuron.C_raw);
Coor = neuron.show_contours(0.8);
figure; 
[CC,jsf] = plot_contours(neuron.A,neuron.Cn,0.1,20,10,Coor);

% A = neuron.reshape(neuron.A, 2);
% imagesc(A(:,:,1))
%% save processed roi
save('neural_data.mat','neuron')
%% load Intan data
% filename = 'RVKC438_190817.rhd';
% clear

filename = 'RVKC441_190923.rhd';

[data,trial] = process_intan_v2(filename);
[Frame,~] = Timing_onset_offset(data.event(7,:), data.ts, 0.5,10,0); % the frame signal is the 7th.
% there are trials without imaging; remove those trial

% remove trials that do not have enough imaging frames.
k=1;
for i = 1:length(trial)
    if isempty(trial(i).Frame) || length(trial(i).Frame)<50
        temp(k) = i;
        k=k+1;
    end
end
trial(temp)=[];
clear temp

% re-calculate the tiemstamps for frames; there is a 2-frame average to the
% imaging data
for i = 1: floor(length(Frame)/2)
    ts_frame(i) = mean(Frame(2*i-1:2*i));
end

save('dataForCNMF.mat','trial','ts_frame','neuron','Coor')
% visualize the calcium traces

% hold on
% [Tone,~]  = Timing_onset_offset(data.event(6,:), data.ts, 0.5,100,0);
% [W,~]     = Timing_onset_offset(data.event(5,:), data.ts, 0.5,10,0);
% [Q,~]     = Timing_onset_offset(data.event(4,:), data.ts, 0.5,10,0);
% [CA,~]    = Timing_onset_offset(data.event(3,:), data.ts, 0.5,10,0);
% [N,~]     = Timing_onset_offset(data.event(2,:), data.ts, 0.5,10,0);
% [S,~]     = Timing_onset_offset(data.event(1,:), data.ts, 0.5,10,0);
% [licks,~] = Timing_onset_offset(-data.analog(1,:), data.ts, -0.2,100,1);
% figure;
% for i = 1:10
%     plot(ts_frame,i+neuron.C_raw(i,:))
%     hold on
% end
% scatter(S,ones(size(S)),'ro','filled')
% scatter(N,ones(size(N)),'bo','filled')
% scatter(CA,ones(size(CA)),'yo','filled')
% scatter(Q,ones(size(Q)),'co','filled')
% scatter(W,ones(size(W)),'ko','filled')
% scatter(Tone,ones(size(Tone)),'mo','filled')
% for i = 1:300
%     plot([licks(i),licks(i)],[0,1],'-k')
% end    
% xlim([0,150])
%% re-organize the data into trial structure
load('dataForCNMF.mat')
%%
taste = {'S','N','CA','Q','W'};
for i = 1:length(trial)
    temp = find(ts_frame> trial(i).tone-3 & ts_frame < trial(i).tone+12); % align data to the tone within [-3s,12s]
    trial(i).Frame = ts_frame(temp)-trial(i).tone;
    trial(i).S_trace = neuron.S(:,temp);
    trial(i).C_raw_trace = neuron.C_raw(:,temp);
    for j = 1:length(taste)
        if ~isnan(trial(i).(taste{j}))
            trial(i).taste = trial(i).(taste{j})(1);
        end
    end
end
% convert trial structure to neuron structure
neuron_data = trial2neuron5tastant_1p(trial);
% stats
neuron_data = stats_1p(trial,neuron_data); % only use deconvolved activity to infer the responses
% length(find([neuron_data.CueRes]==0))/length(neuron_data);
% check each individual neuron
% i=5;
% psth_cue(trial,i)
% psth_taste(trial,i)
% psth_lick(trial,i)
%% imporse more strict criteria. check the overlap between cue and lick
% response
%
k=1;
for i = 1:length(neuron_data)
    if neuron_data(i).CueRes * neuron_data(i).LickRes ==1
        overlap_cueLick(k) =i;
        k = k+1;
    end
end

if exist('overlap_cueLick') ==1
    resp_cueLick = stats_1p_overlapCueLick(trial, overlap_cueLick);
    for i = 1:length(overlap_cueLick)
        neuron_data(overlap_cueLick(i)).LickRes = resp_cueLick(i).LickRes;
    end
end

% imporse more strict criteria. check the overlap between cue and lick
% response
k=1;
for i = 1:length(neuron_data)
    if neuron_data(i).S ==1 && neuron_data(i).N ==1 && neuron_data(i).CA ==1 && ...
            neuron_data(i).Q ==1 && neuron_data(i).W == 1 && neuron_data(i).LickRes == 1
        overlap_tasteLick(k) =i;
        k = k+1;
    elseif neuron_data(i).S ==-1 && neuron_data(i).N ==-1 && neuron_data(i).CA ==-1 && ...
            neuron_data(i).Q ==-1 && neuron_data(i).W == -1 && neuron_data(i).LickRes == -1
        overlap_tasteLick(k) =i;
        k = k+1;        
    end
end


if exist('overlap_tasteLick') == 1
    resp_tasteLick = stats_1p_overlapTasteLick(trial, overlap_tasteLick); 
    for i = 1:length(overlap_tasteLick)
        neuron_data(overlap_tasteLick(i)).S =resp_tasteLick(i).S;
        neuron_data(overlap_tasteLick(i)).N =resp_tasteLick(i).N;
        neuron_data(overlap_tasteLick(i)).CA =resp_tasteLick(i).CA;
        neuron_data(overlap_tasteLick(i)).W =resp_tasteLick(i).W;
        neuron_data(overlap_tasteLick(i)).Q =resp_tasteLick(i).Q;
    end
else
end
%% store the processed data
mkdir('SessionSummary')
cd SessionSummary
Cn = neuron.Cn;
save([animalID,'_',date,'.mat'],'trial','Cn','Coor','neuron_data')
neuron.Cn = Cn;

%% now let's do some summary plots
summary_1p(trial,neuron_data,neuron,Coor)
summary_1p_v2(trial,neuron_data,neuron,Coor)






