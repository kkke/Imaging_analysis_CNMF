function distance = spatialMap_2p_v2_distance(Coor,neuron_data)
%% do some plotting
% plot the spatial map
% f = fieldnames(data_session);
% taste =rmfield(data_session,f(6:end));
% taste = cell2mat(squeeze(struct2cell(taste)))';
% taste(find(taste==-1))=0;
taste = {'S','N','CA','Q','W'};
for j = 1:5
    ind2 = find([neuron_data.(taste{j})]==1);
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

for j = 1:5
    ind2 = find([neuron_data.(taste{j})]==1);
    if isempty(ind2)||length(ind2)==1
        distance.([taste{j},'_pseudo']) = nan;
    else
        ind2 = datasample(1:length(Coor),length(ind2));
        for i = 1:length(ind2)
            centroid(:,i) = mean(Coor{ind2(i)},2);
        end
        distance.([taste{j},'_pseudo']) = pdist(centroid');            
    end
    clear centroid
%     print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
%     title([animalID,' ',date])
end
