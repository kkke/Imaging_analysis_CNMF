file = dir('*.mat')
taste = {'S','N','CA','Q','W'};
color = {'c','m','g','b','k'}
figure
for k = 1:length(taste)
    for i = 1:length(file)
        filename = file(i).name;
        load(filename)
        for j = 1:7
            data(j,i) = mean(summaryData(j).(taste{k}).bout_dur,'omitnan');
        end
    end

% figure;
% plot(mean(data,2),color{k})
hold on
% data(2:6,:)=[];
errorbar(1:7,mean(data,2),std(data,0,2)./sqrt(size(data,2)),color{k})
% ylim([1.5,2.5])
xlim([0,8])
end

clear data
for k = 1:length(taste)
    for i = 1:length(file)
        filename = file(i).name;
        load(filename)
        data(k,i) = mean(summaryData(7).(taste{k}).bout_dur,'omitnan');
%         data(2,i) = mean(summaryData(7).(taste{k}).bout_dur,'omitnan');
    end
end
data = data';
[p,tbl,stats] = anova1(data);
[c,~,~,gnames] = multcompare(stats)
bar_plot_multi(data)

% figure;
% plot(mean(data,2),color{k})
hold on
% data(2:6,:)=[];
errorbar(1:7,mean(data,2),std(data,0,2)./sqrt(size(data,2)),color{k})
% ylim([1.5,2.5])
xlim([0,8])
end
