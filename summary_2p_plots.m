clear
load('lastImagingSession_2p.mat')
temp = [];
for i = 1:length(data)
    cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date,'\1\SessionSummary',])
    load(['summary_',data(i).animalID,'.mat'])
        neuron_data = trial2neuron5tastant_2p_v2(neuron_data,trial);
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
save('allImaging2p_firstSession_S.mat','temp')
temp = neuron_data;
summary_2p(temp)
%% spatial map for each individual session
neuron.Cn = Cn;
spatialMap_1p_v2(neuron,Coor,neuron_data)
%%
taste = {'S','N','CA','Q','W'};
% [11,8,9,12,13]

for i = 1:length(data)
    cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date,'\1\SessionSummary',])
    load(['summary_',data(i).animalID,'.mat'])
%     distance(i) = spatialMap_2p_v2_distance(Coor,neuron_data);
%     distance(i) = spatialMap_1p_distance_best(Coor,neuron_data,2);
     distance(i) = spatialMap_2p_v2_distance_centroid(Coor,neuron_data) % distance using the centroid

    fprintf('Process the session %d\n',i)
end


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

f = fieldnames(sumDistTaste);
for i = 1:length(f)
    sumDistTaste.(f{i})= [distance_sum.(f{i})]*400/512; % convert pixel to distance in um
    h = histogram([distance_sum.(f{i})]);
    h.Normalization = 'probability';
    h.BinWidth = 20;
%     value = h.Values;
%     for j = 1:length(value);
%         time(j) = mean(h.BinEdges(j:j+1));
%     end
% %     forplot(k).(f{i}) = [time;value];
%     clear time
%     close all
    
end
%%
% save('pairwise_distance.mat','forplot','distance_sum')

for i = 1:5
    figure
    plot(forplot(1).(f{i})(1,:),forplot(1).(f{i})(2,:))
    hold on
    for j = 1:length(forplot)
        for k = 1:33
            if k<=size(forplot(j).([f{i},'_pseudo']),2)
                pseudo(j,k) = forplot(j).([f{i},'_pseudo'])(2,k);
            else
                pseudo(j,k) =0;
            end
        end
    end
    x_range = 10:20:(33-1)*20+10;
    boundedline(x_range,mean(pseudo(1:10,:)),(2.579*std(pseudo(1:10,:))./sqrt(size(pseudo(1:10,:),1)))','alpha','k')
    clear pseudo
    title('')
end

f = fieldnames(distance_sum);
for i = 1:5
    figure
    sumDistTaste.(f{i})= [distance_sum.(f{i})]*400/512; % convert pixel to distance in um
    h = histogram(sumDistTaste.(f{i}));
    h.Normalization = 'probability';
    h.BinWidth = 20;
    hold on
    h1 = histogram(sumDistTaste.([f{i},'_pseudo']));
    h1.Normalization = 'probability';
    h1.BinWidth = 20;
    title(f{i})
    kstest2(sumDistTaste.(f{i}),sumDistTaste.([f{i},'_pseudo']))
    ylim([0,0.12])
    xlim([0,500])
end