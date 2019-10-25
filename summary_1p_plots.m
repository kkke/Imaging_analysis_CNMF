clear
load('lastImagingSession_1p.mat')
temp = [];
for i = 1:length(data)
    cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date,'\1\SessionSummary',])
    load([data(i).animalID,'_',data(i).date,'.mat'])
%     neuron_data = trial2neuron5tastant_2p_v2(neuron_data,trial);
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
save('allImaging1p_S.mat','temp')
temp = neuron_data;
summary_1p_allData(temp)
%% spatial map for each individual session
neuron.Cn = Cn;
spatialMap_1p_v2(neuron,Coor,neuron_data)
%%
for i = 1:length(data)
    cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date,'\1\SessionSummary',])
    load([data(i).animalID,'_',data(i).date,'.mat'])
%     distance(i) = spatialMap_2p_v2_distance(Coor,neuron_data);
    distance(i) = spatialMap_1p_distance_best(Coor,neuron_data);
end
taste ={'S','N','CA','Q','W'};    
for i = 1:length(taste)
    distance_sum.(taste{i})=[];
    distance_sum.([taste{i},'_pseudo'])=[];
end
    
for i = 1:length(taste)
    for j = 1:length(distance)
        distance_sum.(taste{i})= [distance_sum.(taste{i}),distance(j).(taste{i})];
        distance_sum.([taste{i},'_pseudo'])=[distance_sum.([taste{i},'_pseudo']),distance(j).([taste{i},'_pseudo'])];
    end
end

%%
save('pairwise_distance.mat','forplot','distance_sum')
f = taste;
for i = 1:5
    figure
    sumDistTaste.(f{i})= [distance_sum.(f{i})]*1.4; % convert pixel to distance in um
    sumDistTaste.([f{i},'_pseudo'])= [distance_sum.([taste{i},'_pseudo'])]*1.4;
    h = histogram(sumDistTaste.(f{i}));
    h.Normalization = 'probability';
    h.BinWidth = 20;
    hold on
    h1 = histogram(sumDistTaste.([f{i},'_pseudo']));
    h1.Normalization = 'probability';
    h1.BinWidth = 20;
    title(f{i})
    [h,p]=kstest2(sumDistTaste.(f{i}),sumDistTaste.([f{i},'_pseudo']))
    ylim([0,0.05])
    xlim([0,2000])
end

for i = 1:length(distance)
    for j = 1:length(taste)
        normalize_dis(i).(taste{j}) = mean(distance(i).(taste{j}))/mean(distance(i).([taste{j},'_pseudo']));
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