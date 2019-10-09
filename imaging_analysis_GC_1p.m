%% data analysis code for 1p data
% load imaging data
path = 'G:\Imaging in GC\ImagingData\RVKC441\191001\1\RVKC441_191001_avg2_reg_source_extraction_reducemin06'
cd(path)
file = '03-Oct_21_21_21.mat';
load(file)
% remove fake neurons
[fakeneuron,neuron_new] = detectfake(neuron);

% view neurons
% i = 1;
neuron_new.save_neurons(); 

% mannully clear the fake neurons

neuron_new2 = fakeneuron_manual(neuron_new);


% neuron_new.viewNeurons([]); 
neuron.viewNeurons(1710,neuron.C_raw);
Coor = neuron.show_contours(0.8);
figure; 
[CC,jsf] = plot_contours(neuron.A,neuron.Cn,0.1,20,[],Coor);

% A = neuron.reshape(neuron.A, 2);
% imagesc(A(:,:,1))
%% save processed roi
save('neural_data.mat','neuron')
%% load Intan data
filename = 'RVKC441_191001.rhd';
[data,trial] = process_intan_v2(filename);
[Frame,~] = Timing_onset_offset(data.event(7,:), data.ts, 0.5,10,0);
% there are trials without imaging; remove those trial
k=1;
for i = 1:length(trial)
    if isempty(trial(i).Frame)
        temp(k) = i;
        k=k+1;
    end
end
trial(temp)=[];
clear temp

% re-calculate the tiemstamps for frames; there is a 2-frame average to the
% data
for i = 1: floor(length(Frame)/2)
    ts_frame(i) = mean(Frame(2*i-1:2*i));
end

save('dataForCNMF.mat','trial','ts_frame','neuron','Coor')
% visualize the calcium traces
% figure;
% plot(ts_frame,neuron.C_raw(1,:))
% hold on
% scatter(S,ones(size(S)),'ro','filled')
% scatter(N,ones(size(N)),'bo','filled')
% scatter(CA,ones(size(CA)),'yo','filled')
% scatter(Q,ones(size(Q)),'co','filled')
% scatter(W,ones(size(W)),'ko','filled')

%% re-organize the data into trial structure
load('dataForCNMF.mat')
taste = {'S','N','CA','Q','W'};
for i = 1:length(trial)
    temp = find(ts_frame> trial(i).tone-3 & ts_frame < trial(i).tone+12);
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
neuron_data = stats_1p(trial,neuron_data);
% length(find([neuron_data.CueRes]==0))/length(neuron_data);
% check each individual neuron
i=1182;
psth_cue(trial,i)
psth_taste(trial,i)
psth_lick(trial,i)
% imporse more strict criteria. check the overlap between cue and lick
% response
k=1;
for i = 1:length(neuron_data)
    if neuron_data(i).CueRes * neuron_data(i).LickRes ==1
        overlap_cueLick(k) =i;
        k = k+1;
    end
end
resp_cueLick = stats_1p_overlapCueLick(trial,neuron, overlap_cueLick);

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
resp_tasteLick = stats_1p_overlapTasteLick(trial,neuron, overlap_tasteLick);

% include the strict criteria into the big data
for i = 1:length(overlap_cueLick)
    if resp_cueLick(i).LickRes ==0
        neuron_data(overlap_cueLick(i)).LickRes = 0;
    end   
end

for i = 1:length(overlap_tasteLick)
    if resp_tasteLick(i).S ==0 && resp_tasteLick(i).N ==0 && resp_tasteLick(i).CA ==0 && ...
            resp_tasteLick(i).Q ==0 && resp_tasteLick(i).W ==0      
        neuron_data(overlap_tasteLick(i)).S =0;
        neuron_data(overlap_tasteLick(i)).N =0;
        neuron_data(overlap_tasteLick(i)).CA =0;
        neuron_data(overlap_tasteLick(i)).W =0;
        neuron_data(overlap_tasteLick(i)).Q =0;
    end
end

%% now let's do some summary plots
summary_1p(trial,neuron_data,neuron,Coor)
summary_1p_v2(trial,neuron_data,neuron,Coor)






