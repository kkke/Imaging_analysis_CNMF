%% prepare for loading data from all sessions
% data from F drive
animalID = {'RVKC368','RVKC377','RVKC402','RVKC403','RVKC404','RVKC405','RVKC418'};
for i = 1:length(animalID)
    data.drive{i} = 'F:/Imaging in GC/ImagingData/';
end
data.session1 = {'180731','180821','181022','181022','181112','181112','190325'};
data.session2 = {'180802','180823','181024','181024','181114','181114','190327'};
data.session3 = {'180807','180828','181029','181029','181119','181119','190401'};
data.animalID = animalID;
clear animalID 
% data from G drive
temp.animalID = {'RVKC425','RVKC426','RVKC428','RVKC429','RVKC438'};        
temp.session1 ={'190701','190701','190624','190624','190807'};        
temp.session2 ={'190703','190703','190626','190626','190809'};        
temp.session3 ={'190708','190708','190701','190701','190814'}; 
for j = 1:length(temp.animalID)
    temp.drive{j} = 'G:/Imaging in GC/ImagingData/';
end
for j = 1:length(temp.animalID)
    data.drive{i+j} = temp.drive{j};
    data.animalID{i+j} = temp.animalID{j};
    data.session1{i+j} = temp.session1{j};
    data.session2{i+j} = temp.session2{j};
    data.session3{i+j} = temp.session3{j};    
end
clearvars -except data
%% summarize all session data
clear data_summary_raw data_summary_dec
sessions = {'session1','session2','session3'};
for j = 1:length(sessions)
    data_summary_raw.(sessions{j}) =[];
    data_summary_dec.(sessions{j}) =[];
    for i = 1:length(data.animalID)
        cd([data.drive{i},'/',data.animalID{i},'/',data.(sessions{j}){i},'/1/SessionSummary/'])
%         load(['summary_',data.animalID{i},'_date.mat'])
        load(['summary_',data.animalID{i},'_date_v2.mat'])
        data_summary_raw.(sessions{j}) = [data_summary_raw.(sessions{j}), data1];
        data_summary_dec.(sessions{j}) = [data_summary_dec.(sessions{j}), neuron2];
    end
end
% save('summaryData.mat','data_summary_dec','data_summary_raw')
save('summaryData_v2.mat','data_summary_dec','data_summary_raw')
%% run analysis package
%% Find the cue response, lick response and taste response
sessions = {'session1','session2','session3'};
load('summaryData_v2.mat') % data with 0.5 s before taste or lick as baseline test taste and lick response
for i = 1:length(sessions)
all_align.(sessions{i}) = data_summary_raw.(sessions{i});
end
load('summaryData.mat') % data with 1 s before tone as baseline test taste and lick response
for i = 1:length(sessions)
    all.(sessions{i}) = data_summary_raw.(sessions{i});
end
for i = 1:length(sessions)
    datasave(i) = analysispackage(all.(sessions{i}),all_align.(sessions{i}));
end
%% summary plot
summaryplot(datasave,sessions)