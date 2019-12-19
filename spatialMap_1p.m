function spatialMap_1p(neuron,Coor,ind_cue,ind_lick,ind_taste)

%% do some plotting
cue_lick   = intersect(ind_cue,ind_lick);
lick_taste = intersect(ind_lick,ind_taste);
cue_taste = intersect(ind_cue,ind_taste);
multi = [cue_lick',lick_taste',cue_taste'];
multi = unique(multi);

cue = ind_cue;
lick = ind_lick;
taste = ind_taste;
% cue   = setdiff(ind_cue,multi);
% % lick  = setdiff(ind_lick,multi);
% % taste =setdiff(ind_taste,multi);

% plot the spatial map
figure;imshow(neuron.Cn,[0.3,.8])
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
% title([animalID,'  ',date])


% for i = 1:length(multi)
%     
%         plot(data_session(multi(i)).coordinates(1,:), data_session(multi(i)).coordinates(2,:), 'c', 'LineWidth', 1)
%         % red means cue response
%         hold on
% end