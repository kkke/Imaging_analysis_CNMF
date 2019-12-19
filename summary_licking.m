file = dir('*.mat')
taste = {'S','N','CA','Q','W'};
color = {'c','m','g','b','k'}
% parameter = {'bout_dur'};
% parameter = {'iti'};
parameter = {'lickIni'};
figure
clear data
for k = 1:length(taste)
    for i = 1:length(file)
        filename = file(i).name;
        load(filename)
        for j = 1:7
            data(j,i) = mean(summaryData(j).(taste{k}).(parameter{1}),'omitnan');
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
%%
clear data
for k = 1:length(taste)
    for i = 1:length(file)
        filename = file(i).name;
        load(filename)
        data(k,i) = mean(summaryData(7).(taste{k}).(parameter{1}),'omitnan');
%         data(2,i) = mean(summaryData(7).(taste{k}).bout_dur,'omitnan');
    end
end
data = data';
[p,tbl,stats] = anova1(data);
[c,~,~,gnames] = multcompare(stats)
bar_plot_multi(data)
%% extract the latency between lick initation and taste delivery
for k = 1:length(taste)
    for i = 1:length(file)
        filename = file(i).name;
        load(filename)
        for j = 1:length(summaryData(7).(taste{k}).idx)
            idx = summaryData(7).(taste{k}).idx;
            temp(j) = summaryData(7).trial(idx(j)).(taste{k})(1)- summaryData(7).(taste{k}).lickIni(j);
        end
        temp_latency(i,k) = mean(temp);
        clear temp
    end
end
