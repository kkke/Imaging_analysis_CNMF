function [distance, distance_centroid] = spatialMap_1p_v5(neuron,Coor,neuron_data, best, fig)
%% 
%% do some plotting
% plot the spatial map
% f = fieldnames(data_session);
% taste =rmfield(data_session,f(6:end));
% taste = cell2mat(squeeze(struct2cell(taste)))';
% taste(find(taste==-1))=0;
color = lines(5);
taste = {'S','N','CA','Q','W'};
if fig == 1
    figure
    imshow(neuron.Cn);
    for j = 1:5
        fig = figure;
        ind2 = best.(taste{j});
        ind2 = best.(taste{j});
    
        hold on
        for i = 1:length(neuron_data)
            if ~isempty(find(ind2 ==i))
                h{j} = plot(Coor{i}(1,:), Coor{i}(2,:), 'color',color(j,:), 'LineWidth', 1)
                red means cue response
                hold on
                text(mean(Coor{i}(1,:)), mean(Coor{i}(2,:)),num2str(i),'Color',[1,0,1],'FontSize',12)
            else
                plot(Coor{i}(1,:), Coor{i}(2,:), 'y', 'LineWidth', 1)
                text(data_session(i).centroid(2), data_session(i).centroid(1),num2str(i),'Color',[0,1,1],'FontSize',8)
            end
        end
        title(['Best ',taste{j}])
        print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
        title([animalID,' ',date])
    end
    legend([h{1}, h{2}, h{3}, h{4}, h{5}], {'S', 'N', 'CA', 'Q', 'W'})
end

for j = 1:5
    ind2 = best.(taste{j});
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
        ind2 = best.(taste{j});
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

% based on centroids
taste = {'S','N','CA','Q','W'};
for j = 1:5
    ind2 = best.(taste{j});
    if isempty(ind2)||length(ind2)==1
        distance_centroid.(taste{j}) = nan;
    else
        for i = 1:length(ind2)
            centroid(:,i) = mean(Coor{ind2(i)},2);
        end
        distance_centroid.(taste{j}).avg_centroid = mean(centroid,2);
        distance_centroid.(taste{j}).centroid = centroid;
        distance_centroid.(taste{j}).distance = sqrt(sum((centroid - distance_centroid.(taste{j}).avg_centroid).^2));;
    end
    clear centroid
    %     print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
    %     title([animalID,' ',date])
end
