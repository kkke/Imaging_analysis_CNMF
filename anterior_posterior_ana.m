taste = {'S','N','CA','Q'};
temp.S_resp =[];
temp.N_resp =[];
temp.CA_resp=[];
temp.Q_resp =[];

for i = 1:length(data)
    cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date,'\1\SessionSummary',])
    load('Best_anterior_posterior_C_raw.mat')
    for j = 1:length(taste)
        temp.([taste{j},'_resp']) = [temp.([taste{j},'_resp']); anterior.([taste{j},'_resp'])];
    end
end
%%
load('anterior_resp_C_raw.mat')
f = fieldnames(temp);
y = [];
group =[];
for i = 1:length(f)
    y = [y; temp.(f{i})];
    group = [group; i*ones(size(temp.(f{i})))];
end
[~,~,stats]=anova1(y,group);
[c,~,~,gnames] = multcompare(stats);