function distance = spatialMap_1p_distance_best(Coor,neuron_data,flag)
f = {'S','N','CA','Q','W'};
for i = 1:length(neuron_data)
    for j = 1:length(f)
        taste(i).(f{j}) = neuron_data(i).(f{j});
    end
end
%% Find the cue response, lick response and taste response
taste = cell2mat(squeeze(struct2cell(taste)))';
taste_all =taste(:,1:5);
taste_all(find(taste_all ==-1))=0; % only analyze the excitatory response
taste_num = sum(taste_all(:,1:5),2);
ind_taste      = find(taste_num>0);
temp_taste = taste_all(ind_taste,:);
switch flag
    case 1
        [taste_time, data] = psth_taste_pop(neuron_data,ind_taste);
    case 2
        [taste_time, data] = psth_taste_pop_2p(neuron_data,ind_taste); % for 2p data
end
for i = 1:length(ind_taste)
    idx = find(taste_time.S>0 & taste_time.S <3.5);
    resp_ap(i,1) = max(data.S(i,idx));
    resp_ap(i,2) = max(data.N(i,idx));
    resp_ap(i,3) = max(data.CA(i,idx));
    resp_ap(i,4) = max(data.Q(i,idx));
    resp_ap(i,5) = max(data.W(i,idx));
end
resp_ap = resp_ap.*temp_taste;
resp_ap(find(mean(resp_ap,2)<=0),:)=[];
[M, I] = max(resp_ap,[],2);
id = {'S','N','CA','Q','W'};
for i = 1:length(id)
    best.(id{i}) = find(I ==i );
    best.summary(i) = length(find(I ==i ));
end

taste = {'S','N','CA','Q','W'};
for j = 1:5
    ind2 = ind_taste(best.(taste{j}));
    if isempty(ind2)||length(ind2)==1
        distance.(taste{j}) = nan;
    else
        for i = 1:length(ind2)
            centroid(:,i) = mean(Coor{ind2(i)},2);
        end
        distance.(taste{j}) = pdist(centroid');            
    end
    clear centroid
%     print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
%     title([animalID,' ',date])
end
for k = 1:1000
    for j = 1:5
        ind2 = ind_taste(best.(taste{j}));
        if isempty(ind2)||length(ind2)==1
            distance.([taste{j},'_pseudo']) = nan;
        else
            ind2 = datasample(1:length(Coor),length(ind2));
            for i = 1:length(ind2)
                centroid(:,i) = mean(Coor{ind2(i)},2);
            end
            distance.([taste{j},'_pseudo']){k} = pdist(centroid');
        end
        clear centroid
        %     print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
        %     title([animalID,' ',date])
    end
end