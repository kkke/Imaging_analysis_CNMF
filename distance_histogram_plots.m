save('pairwise_distance_1p.mat','distance','distance_sum')
f = taste;
for j = 1:length(distance)
    for i = 1:length(f)
        figure
        scale = 2000/1280 % convert pixel to distance in um: 1p
%         scale = 450/512 % convert pixel to distance in um: 2p
        sumDistTaste(j).(f{i})= [distance_sum(j).(f{i})]*scale; 
        sumDistTaste(j).([f{i},'_pseudo'])= [distance_sum(j).([taste{i},'_pseudo'])]*scale;
        h = histogram(sumDistTaste(j).([f{i},'_pseudo']));
        h.Normalization = 'probability';
        h.NumBins = 40;
        hold on
        plot([[sumDistTaste(j).(f{i})],sumDistTaste(j).(f{i})],[0,0.05])
        [~, I] = sort([distance_sum(j).([taste{i},'_pseudo'])]*scale);
        temp = sumDistTaste(j).([f{i},'_pseudo'])(I(49));
        plot([temp,temp],[0,0.1],'--k')
        xlim([100,600])
%         xlim([550,850])
%       xlim([300,800])
%         xlim([50,250])
      title ([f{i},'_',data(j).animalID])
    end
end
