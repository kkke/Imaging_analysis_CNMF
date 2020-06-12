%%
for i = 1:10
    data(i).disk = 'E:'
end
for i = 11:length(data)
    data(i).disk = 'F:'
end
%%
temp = [];
for i = 1:length(data)
    cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date])
    file = dir('*.rhd');
    % for k = 1:length(file)
    filename = file(1).name
    [~,trial] = process_intan_v2(filename);
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
    temp = [temp,summaryData];
    clear summaryData
end
%%
summaryData = temp;

%% Let's average by animal;
load('summaryLicking.mat')
%clear data
taste = {'S','N','CA','Q','W'};
color = {'c','m','g','b','k'}
% parameter = {'bout_dur'};
parameter = {'iti'};
% parameter = {'lickIni'};
animalID = unique({summaryData.animal});
data_sub = [];
data_temp = [];
data = [];
for i = 1 : length(animalID)
    idx = strcmp({summaryData.animal}, animalID{i});
    data_sub = summaryData(idx);
    for j = 1:length(data_sub)
        for k = 1:length(taste)
            data_temp(j,k) = mean(data_sub(j).(taste{k}).(parameter{1}),'omitnan');
        end
        %         data(2,i) = mean(summaryData(7).(taste{k}).bout_dur,'omitnan');
    end
    data_temp = mean(data_temp);
    data(i,:) = data_temp;
    data_temp = [];
end
% parameter = {'iti'};
% parameter = {'lickIni'};
[p,tbl,stats] = anova1(data);
[c,~,~,gnames] = multcompare(stats)
bar_plot_multi(data)
ylim([0,4])
%% save the matrix into table
T = array2table(data,'VariableNames',taste);
writetable(T,'Licking-InterLickInterval-Habituated.xls')
%% plot licking raster
load('ImagingFiles.mat')
data1 = data;
for i = 1:length(data1)
    cd([data1(i).disk,'\Imaging in GC\ImagingData\',data1(i).animalID,'\',data1(i).date])
    beha_2p  
end