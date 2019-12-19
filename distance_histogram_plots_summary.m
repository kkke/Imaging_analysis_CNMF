taste={'CueRes','LickRes'};
for i = 1:length(taste)
    distance_sum.(taste{i})=[];
    distance_sum.([taste{i},'_pseudo'])=[];
end

for i = 1:length(taste)
    for j = 1:length(distance)
        if isnan(distance(j).(taste{i}))
        else
            distance_sum.(taste{i})= [distance_sum.(taste{i}),distance(j).(taste{i})];
            distance_sum.([taste{i},'_pseudo'])=[distance_sum.([taste{i},'_pseudo']),distance(j).([taste{i},'_pseudo']){2}];
        end
        end
end

f = fieldnames(sumDistTaste);
for i = [1,3]
    figure
    sumDistTaste.(f{i})= [distance_sum.(f{i})]*400/512; % convert pixel to distance in um
    h = histogram(sumDistTaste.(f{i}));
    h.Normalization = 'probability';
    h.BinWidth = 20;
%     h.NumBins = 40;
    hold on
    h1 = histogram(sumDistTaste.([f{i},'_pseudo']));
    h1.Normalization = 'probability';
    h1.BinWidth = 20;
%     h1.NumBins = 40;
    title(f{i})
%     kstest2(sumDistTaste.(f{i}),sumDistTaste.([f{i},'_pseudo']))
    ylim([0,0.12])
    xlim([0,500])
end