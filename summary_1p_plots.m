clear
load('lastImagingSession_1p.mat')
% the following is to re-organize the data; there are two different traces:
% one is for deconvolved, and the other is for raw traces;
% 
temp = [];
for i = 1:length(data)
    cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date,'\1\SessionSummary',])
    load([data(i).animalID,'_',data(i).date,'.mat'])
    neuron_data = trial2neuron5tastant_2p_v2(neuron_data,trial);
    for j = 1:length(neuron_data)
        neuron_data(j).Coor = Coor{j};
        for k = 1:length(trial)
            neuron_data(j).S_trace(k,:) = trial(k).S_trace(j,1:124);
            neuron_data(j).C_raw_trace(k,:) = trial(k).C_raw_trace(j,1:124);
            neuron_data(j).framT(k,:) = trial(k).Frame(1:124); 
        end
    end
    temp = [temp,neuron_data];
    clear neuron_data
end
save('allImaging1p_C_raw.mat','temp')
temp = neuron_data;
summary_1p_allData(temp)
%% spatial map for each individual session
neuron.Cn = Cn;
spatialMap_1p_v2(neuron,Coor,neuron_data)
% spatialMap_1p_v4(neuron,Coor,neuron_data)
summary_1p(trial,neuron_data, neuron,Coor)
spatialMap_1p_best(neuron,Coor,neuron_data,1) % plot neurons with best response
%%
for i = 1:length(data)
    cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date,'\1\SessionSummary',])
    load([data(i).animalID,'_',data(i).date,'.mat'])
%     distance(i) = spatialMap_2p_v2_distance(Coor,neuron_data);
%     distance(i) = spatialMap_1p_distance_best(Coor,neuron_data,1);
     distance(i) = spatialMap_1p_distance_best_centroid(Coor,neuron_data,1) % distance using the centroid
    fprintf('Process the session %d\n',i)
end
% taste = {'CueRes','LickRes'};
taste ={'S','N','CA','Q','W'};    
for i = 1:length(taste)
    distance_sum.(taste{i})=[];
    distance_sum.([taste{i},'_pseudo'])=[];
end
    
for i = 1:length(taste)
    for j = 1:length(distance)
        if isnan(distance(j).(taste{i}))
            distance_sum(j).(taste{i})= NaN;
            distance_sum(j).([taste{i},'_pseudo'])=NaN;
            distance_sum(j).([taste{i},'_pvalue'])=NaN;
        else
            distance_sum(j).(taste{i})= mean(distance(j).(taste{i}));
            for k = 1:length(distance(j).([taste{i},'_pseudo']))
                temp_distance(k) = mean(distance(j).([taste{i},'_pseudo']){k});
            end
            distance_sum(j).([taste{i},'_pseudo'])=temp_distance;
            clear temp_distance
            distance_sum(j).([taste{i},'_pvalue'])  = 1-length(find(distance_sum(j).([taste{i},'_pseudo'])>= distance_sum(j).(taste{i})))/1000;
        end
    end
end

%%


for i = 1:length(distance)
    for j = 1:length(taste)
        normalize_dis(i).(taste{j}) = mean(distance_sum(i).(taste{j}))/mean(distance_sum(i).([taste{j},'_pseudo']));
    end
end

for i = 1:length(taste)
    a(i,:) = [normalize_dis.(taste{i})];
end
a = a';
figure
for i = 1:4
scatter(i*ones(size(a(:,1))),a(:,i))
hold on
end
ylim([0,2])
xlim([0,5])