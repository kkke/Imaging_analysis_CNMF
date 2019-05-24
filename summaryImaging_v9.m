% %%
% clear
% % Load each Imaging data from Session 3
% file = {'RVKC368\180807','RVKC368\180809','RVKC368\180814','RVKC377\180828','RVKC402\181029','RVKC403\181029'...
%     ,'RVKC403\181030','RVKC403\181031','RVKC404\181119','RVKC405\181119','RVKC405\181120'};
function [all] = summaryImaging_v9(file)
data2 = [];
taste = {'S','N','CA','Q','W'};
for j = 1:length(file)
    iter =[];
    animalID = file{j}(1:7);
    date     = file{j}(9:end);
    cd(['F:\Imaging in GC\ImagingData\',file{j},'\1\'])
    load('dataForCNMF.mat')
    [lickIni, bout_dur] = lickIniateTime(trial); % new add  
    [Ini, Dur] = getLickingParameter(trial,lickIni,bout_dur);
    all(j).animalID = animalID;
    all(j).date     = date;
    for i = 1:length(taste)
        all(j).(['Ini_',taste{i}])=mean([Ini.(taste{i})]);
        all(j).(['Dur_',taste{i}])=mean([Dur.(taste{i})]);
    end

end
