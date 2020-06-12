save('distance_centroid_1p_best.mat','distance','distanceSum','summary')
%%
f = fieldnames(distance);
for k = 1:length(distance)
    for i = 1:length(f)
        otherTaste = setdiff(f,f{i});
        for j = 1:length(otherTaste)
            distance(k).(f{i}).(['distance_',otherTaste{j}]) = sqrt(sum((distance(k).(f{i}).centroid - distance(k).(otherTaste{j}).avg_centroid).^2));

        end
        
    end
end

% plot the distance within a ground to the centroid
scale = 450/512; % convert pixel to distance in um: 2p
% scale = 2000/1280; % convert pixel to distance in um: 1p
for k = 1:length(distance) % [11,8,9,12,13]this list is for 2p, otherwise is length(distance)
    for i = 1:length(f)
        f2 = fieldnames(distance(k).(f{i}));
        f2 = setdiff(f2,{'avg_centroid','centroid'})
        figure
        for j = 1:length(f2)
            distanceSum(k).(f{i}).distanceSummary(j,:) = distance(k).(f{i}).(f2{j});
            bar(j,mean(distance(k).(f{i}).(f2{j}))* scale)
            hold on
            errorbar(j,mean(distance(k).(f{i}).(f2{j})* scale),std(distance(k).(f{i}).(f2{j}))/sqrt(length(distance(k).(f{i}).(f2{j})))* scale)
        end
        xticks([1,2,3,4,5])
        xticklabels({[f{i},'-',f{i}],[f{i},'-',f2{2}(10:end)],[f{i},'-',f2{3}(10:end)],[f{i},'-',f2{4}(10:end)],[f{i},'-',f2{5}(10:end)]})
    end
end

%% for summary across sessions without significant from random
for j = 1:length(f)
    summary.(f{j}) =[];
    for i = 1:length(distanceSum)
        summary.(f{j}) = [summary.(f{j});distanceSum(i).(f{j}).distanceSummary']
    end
   
end
for i = 1:length(f2)
    f2 = fieldnames(distance(1).(f{i}));
    f2 = setdiff(f2,{'avg_centroid','centroid'})
    bar_plot_multi(summary.(f{i})*scale,1)
    ylim([0,150])
    xticks([1,2,3,4,5])
    xticklabels({[f{i},'-',f{i}],[f{i},'-',f2{2}(10:end)],[f{i},'-',f2{3}(10:end)],[f{i},'-',f2{4}(10:end)],[f{i},'-',f2{5}(10:end)]})
end

%% calculate the ratio between within cluster distance to across cluster distance
for i = 1:length(distanceSum)
    for j = 1:length(f)
        X = distanceSum(i).(f{j}).distanceSummary';
        X_m = mean(X);
        ratio.(f{j})(i) = X_m(1)/mean(X_m(2:end));
    end
end
clear temp
for i = 1:length(f)
    temp(:,i) = (ratio.(f{i}))';
end
figure
boxplot(temp,'Notch','on','Labels',{'S','N','CA','Q','W'})
ylim([0,1.2])
   
