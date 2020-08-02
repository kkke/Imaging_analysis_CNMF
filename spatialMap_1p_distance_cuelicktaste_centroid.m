function distance = spatialMap_1p_distance_cuelicktaste_centroid(Coor,neuron_data,flag)
f = {'S','N','CA','Q','W','CueRes', 'LickRes'};
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
best.taste      = find(taste_num>0);
best.cue        = find(taste(:,6)>=1);
best.lick       = find(taste(:,7)==1);

taste = {'cue', 'lick', 'taste'};
for j = 1:3
    ind2 = best.(taste{j});
    if isempty(ind2)||length(ind2)==1
        distance.(taste{j}) = nan;
    else
        for i = 1:length(ind2)
            centroid(:,i) = mean(Coor{ind2(i)},2);
        end
        distance.(taste{j}).avg_centroid = mean(centroid,2);
        distance.(taste{j}).centroid = centroid;
        distance.(taste{j}).distance = sqrt(sum((centroid - distance.(taste{j}).avg_centroid).^2));;
    end
    clear centroid
    %     print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
    %     title([animalID,' ',date])
end
% for k = 1:1000
%     for j = 1:5
%         ind2 = ind_taste(best.(taste{j}));
%         if isempty(ind2)||length(ind2)==1
%             distance.([taste{j},'_pseudo']) = nan;
%         else
%             ind2 = datasample(1:length(Coor),length(ind2));
%             for i = 1:length(ind2)
%                 centroid(:,i) = mean(Coor{ind2(i)},2);
%             end
%             distance.([taste{j},'_pseudo']){k} = pdist(centroid');
%         end
%         clear centroid
%         %     print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
%         %     title([animalID,' ',date])
%     end
% end