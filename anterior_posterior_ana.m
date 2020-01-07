taste = {'S','N','CA','Q','W'};
temp.S_resp =[];
temp.N_resp =[];
temp.CA_resp=[];
temp.Q_resp =[];
temp.W_resp =[];

for i = 1:length(data)
    cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date,'\1\SessionSummary',])
    load('Best_anterior_posterior_C_raw.mat')
%     load('Best_anterior_posterior_S.mat')
    for j = 1:length(taste)
%         temp.([taste{j},'_resp']) = [temp.([taste{j},'_resp']); anterior.([taste{j},'_resp'])];
        temp.([taste{j},'_resp']) = [temp.([taste{j},'_resp']); posterior.([taste{j},'_resp'])];

    end
    clear anterior posterior
end 
%%
load('anterior_resp_S.mat')
load('posterior_resp_S.mat')
% calculate the ratio
for i = 1:length(taste)
    contable(1,i) = length(temp.([taste{i},'_resp']));
end
contable(2,:) = sum(contable(1,:))-contable;
figure
bar(contable(1,:)/sum(contable(1,:)))
xticks([1,2,3,4,5])
xticklabels({taste{1},taste{2},taste{3},taste{4},taste{5}})
ylim([0,0.3])
clear contable
% calculate the evoked response
for i = 1:length(taste)
    resp_m(1,i) = mean(temp.([taste{i},'_resp']));
    resp_sem(1,i) = std(temp.([taste{i},'_resp']))/sqrt(length(temp.([taste{i},'_resp'])));
end
figure
bar(resp_m)
hold on
errorbar(resp_m,resp_sem)
xticks([1,2,3,4,5])
xticklabels({taste{1},taste{2},taste{3},taste{4},taste{5}})
ylim([0,0.5])

f = fieldnames(temp);
y = [];
group =[];
for i = 1:length(f)
    y = [y; temp.(f{i})];
    group = [group; i*ones(size(temp.(f{i})))];
end
[~,~,stats]=anova1(y,group);
[c,~,~,gnames] = multcompare(stats);