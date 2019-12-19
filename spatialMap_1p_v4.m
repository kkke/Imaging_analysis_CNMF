function spatialMap_1p_v4(neuron,Coor,neuron_data)
%% do some plotting-for narrowly tuned neurons
% plot the spatial map
% f = fieldnames(data_session);
% taste =rmfield(data_session,f(6:end));
% taste = cell2mat(squeeze(struct2cell(taste)))';
% taste(find(taste==-1))=0;
taste = {'S','N','CA','Q','W'};
for j = 1:length(taste)
    for i = 1:length(neuron_data)
        neuron_data_temp(i,j) = neuron_data(i).(taste{j});
    end
end
neuron_data_temp(neuron_data_temp<0)=0;
idx_narrow = find(sum(neuron_data_temp,2)==1);
for j = 1:5
    fig = figure;
    imshow(neuron.Cn,[0.05,1]);
    ind2 = find([neuron_data.(taste{j})]==1);
    ind = intersect(idx_narrow,ind2);
    hold on
    for i = 1:length(neuron_data)
        if ~isempty(find(ind ==i))
            plot(Coor{i}(1,:), Coor{i}(2,:), 'r', 'LineWidth', 1)
            hold on
            
        else
            plot(Coor{i}(1,:), Coor{i}(2,:), 'w', 'LineWidth', 1)
            
        end
    end
    title(taste{j})
%     print(fig,['Spatial_',animalID,'_',date,'_',taste{j}],'-dpdf')
%     title([animalID,' ',date])
end

figure;imshow(neuron.Cn,[0.3,.8])
cue = find([neuron_data.CueRes]>=1);
lick = find([neuron_data.LickRes]>=1);
multi = intersect(cue,lick);
hold on
for i = 1:length(Coor)
    if ~isempty(find(cue ==i))
        plot(Coor{i}(1,:), Coor{i}(2,:), 'b', 'LineWidth', 1)
        % red means cue response
        hold on
%         text(data_session(i).centroid(2), data_session(i).centroid(1),num2str(i),'Color',[1,0,0],'FontSize',8)
%     elseif ~isempty(find(taste ==i))
%         plot(Coor{i}(1,:), Coor{i}(2,:), 'r', 'LineWidth', 1)
        % white means taste response
%         text(data_session(i).centroid(2), data_session(i).centroid(1),num2str(i),'Color',[1,1,1],'FontSize',8)
    elseif ~isempty(find(lick ==i))
        plot(Coor{i}(1,:),Coor{i}(2,:), 'g', 'LineWidth', 1)
        % green means lick response
%         text(data_session(i).centroid(2), data_session(i).centroid(1),num2str(i),'Color',[0,1,0],'FontSize',8)
    elseif ~isempty(find(multi ==i))
        plot(Coor{i}(1,:), Coor{i}(2,:), 'c', 'LineWidth', 1)
        
    else
%         plot(Coor{i}(1,:), Coor{i}(2,:), 'y', 'LineWidth', 1)
%         text(data_session(i).centroid(2), data_session(i).centroid(1),num2str(i),'Color',[0,1,1],'FontSize',8)
    end
end
