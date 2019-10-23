load('lastImagingSession.mat')
temp = [];
for i = 1:length(data)
    cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date,'\1\SessionSummary',])
    load(['summary_',data(i).animalID,'.mat'])
    for j = 1:length(neuron_data)
        neuron_data(j).Coor = Coor{j};
        for k = 1:length(trial)
            neuron_data(j).S_trace(k,:) = trial(k).S_trace(j,:);
            neuron_data(j).C_raw_trace(k,:) = trial(k).C_raw_trace(j,:);
            neuron_data(j).framT(k,:) = trial(k).Frame; 
        end
    end
    temp = [temp,neuron_data];
    clear neuron_data
end
summary_2p(temp)
