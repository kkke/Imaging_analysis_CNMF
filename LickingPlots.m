function LickingPlots(Lickingpara)
taste = {'S','N','CA','Q','W'};
for i = 1:length(taste)
    Ini(i,:) = [Lickingpara.(['Ini_',taste{i}])];
end
Ini = Ini';
figure;
bar(mean(Ini,1))
hold on
errorbar(mean(Ini,1),std(Ini,1)/sqrt(size(Ini,1)))
ylim([0,3])
tasteLabel = {'S','N','CA','Q','W'};
set(gca,'xticklabel',tasteLabel)
ylabel('Latency of Lick Initiation (s)')
p = anova1(Ini,[],'off');

for i = 1:length(taste)
    Dur(i,:) = [Lickingpara.(['Dur_',taste{i}])];
end
Dur = Dur';
figure;
bar(mean(Dur,1))
hold on
errorbar(mean(Dur,1),std(Dur,1)/sqrt(size(Dur,1)))
ylim([0,5])
tasteLabel = {'S','N','CA','Q','W'};
set(gca,'xticklabel',tasteLabel)
ylabel('Duration of Licking (s)')
p = anova1(Dur,[],'off');