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
for i = 1:length(trial)
    temp = find(ts_frame> trial(i).tone-3 & ts_frame < trial(i).tone+12);
    trial(i).Frame = ts_frame(temp)-trial(i).tone;
    trial(i).S_trace = neuron.S(:,temp);
    trial(i).C_raw_trace = neuron.C_raw(:,temp);  
end
[lickIni bout_dur] = lickIniateTime(trial);
psth_cue(trial,6)
psth_taste(trial,4)


