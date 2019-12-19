function distance = spatialMap_2p_v2_distance_centroid(Coor,neuron_data)
%% do some plotting
% plot the spatial map
% f = fieldnames(data_session);
% taste =rmfield(data_session,f(6:end));
% taste = cell2mat(squeeze(struct2cell(taste)))';
% taste(find(taste==-1))=0;
taste = {'S','N','CA','Q','W'}; % calculate distance between taste
% taste = {'CueRes','LickRes'}; % calculate distance between cue and lick

for j = 1:length(taste)
    ind2 = find([neuron_data.(taste{j})]>=1);
    if isempty(ind2)||length(ind2)==1
        distance.(taste{j}) = nan;
    else
        for i = 1:length(ind2)
            centroid(:,i) = mean(Coor{ind2(i)},2);
        end
        distance.(taste{j}).avg_centroid = mean(centroid,2);
        distance.(taste{j}).centroid = centroid;
        distance.(taste{j}).distance = sqrt(sum((centroid - distance.(taste{j}).avg_centroid).^2));; 
%         [idx,d] = knnsearch(centroid', centroid', 'k', 2);
%         distance.(taste{j}) = d(:,2);
    end
    clear centroid d
%     print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
%     title([animalID,' ',date])
end

% for k = 1:1000
%     for j = 1:length(taste)
%         ind2 = find([neuron_data.(taste{j})]==1);
%         if isempty(ind2)||length(ind2)==1
%             distance.([taste{j},'_pseudo']) = nan;
%         else
%             ind2 = datasample(1:length(Coor),length(ind2),'Replace',false);
%             for i = 1:length(ind2)
%                 centroid(:,i) = mean(Coor{ind2(i)},2);
%             end
%             distance.([taste{j},'_pseudo']){k} = pdist(centroid');
% %             [idx,d] = knnsearch(centroid', centroid', 'k', 2);
% %             distance.([taste{j},'_pseudo']){k} = d(:,2);
%         end
%         clear centroid
%         %     print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
%         %     title([animalID,' ',date])
%     end
% end
