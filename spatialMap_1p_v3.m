function spatialMap_1p_v3(neuron,Coor,neuron_data, best, ind_taste)
%% 
%% do some plotting
% plot the spatial map
% f = fieldnames(data_session);
% taste =rmfield(data_session,f(6:end));
% taste = cell2mat(squeeze(struct2cell(taste)))';
% taste(find(taste==-1))=0;
taste = {'S','N','CA','Q','W'};
for j = 1:5
    fig = figure;
    imshow(neuron.Cn);
    ind2 = ind_taste(best.(taste{j}));
    hold on
    for i = 1:length(neuron_data)
        if ~isempty(find(ind2 ==i))
            plot(Coor{i}(1,:), Coor{i}(2,:), 'r', 'LineWidth', 1)
            % red means cue response
            hold on
%             text(data_session(i).centroid(2), data_session(i).centroid(1),num2str(i),'Color',[1,0,0],'FontSize',8)
        else
%             plot(Coor{i}(1,:), Coor{i}(2,:), 'y', 'LineWidth', 1)
%             text(data_session(i).centroid(2), data_session(i).centroid(1),num2str(i),'Color',[0,1,1],'FontSize',8)
        end
    end
    title(['Best ',taste{j}])
%     print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
%     title([animalID,' ',date])
end
