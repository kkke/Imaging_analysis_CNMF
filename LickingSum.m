%% behaviral analysis for 2p rig
%% Step 1: load data from Intan
clear
file = dir('*.rhd');
filename = file.name
[data,trial] = process_intan_v2(filename);
[lickIni bout_dur iti] = lickIniateTime(trial);
summaryData. animal = filename(1:7);
summaryData.date    = filename(9:end-4);
summaryData.trial   = trial;

taste = {'S','N','CA','Q','W'};
for i = 1:length(taste)
    summaryData.(taste{i}).idx =[];
    for j = 1:length(trial)
        if ~isnan(trial(j).(taste{i}))
         summaryData.(taste{i}).idx = [summaryData.(taste{i}).idx,j];
        end        
    end
    summaryData.(taste{i}).lickIni = lickIni(summaryData.(taste{i}).idx);
    summaryData.(taste{i}).bout_dur = bout_dur(summaryData.(taste{i}).idx);
    summaryData.(taste{i}).iti      = iti(summaryData.(taste{i}).idx);
end
%%
save('summayLicking.mat','summaryData')
temp = summaryData;
%%
cd('G:\Imaging in GC\ImagingData\SummaryBehavior')
if exist([summaryData.animal,'.mat'])== 2
    load([summaryData.animal,'.mat'])
    summaryData = [summaryData,temp];
    save([summaryData(1).animal,'.mat'],'summaryData')
else
    save([summaryData.animal,'.mat'],'summaryData')
end
cd('G:\Imaging in GC\ImagingData')   