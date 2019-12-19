% Imaging analysis for GC project
%% rigister your image
% segment your image with Segmentation_CaImAN
%% load imaging data and ROI
% clear
% animalID = 'RVKC377';
% date     = '180821';
function imaging_analysis_GC_2p(animalID,date,path)
%%
% path = 'F:\Imaging in GC\ImagingData\';
% path = 'G:\Imaging in GC\ImagingData\'; % for data stored in G disk
cd([path,animalID,'\',date,'\1\'])
file = 'data_CNMF.mat';
load(file)
% Fcell = F_dff;  % extract the neuron;
[CC,jsf,im] = plot_contours(A_keep,Cn,options,1);
close all
clearvars -except F_dff S_dec C_dec path date animalID CC jsf Cn

% clearvars -except Y_r cc Cn
% clear
% filename = 'reg2.tif'
% data=MulRoiANA(filename)
% load C_df data from CNMF result
% %%
% save('data.mat','data')
%% load the event
cd([path,animalID,'\',date])
file2 = [animalID,'_',date,'.rhd'];
[analog,trial] = process_intan_v2(file2);

% [trial] = imaging_analysis_GC_v7(F_dff,trial,animalID,date);
% [trial2] = imaging_analysis_GC_v7(S_dec,trial,animalID,date); 

dF = reshape(full(F_dff), size(F_dff,1),60,[]);
S_dF = reshape(full(S_dec), size(S_dec,1),60,[]);
% for i = 1:length(trial)
%     trial(i).trace = dF(:,:,i);
% end
%% get the timestamps of each frame after 5 time averaging
for i = 1:length(trial)
    idx = 3:5:300;
    trial(i).Frame =trial(i).Frame(idx);
end

taste = {'S','N','CA','Q','W'};
for i = 1:length(trial)
    trial(i).S_trace = S_dF(:,:,i);
    trial(i).C_raw_trace = dF(:,:,i);
    for j = 1:length(taste)
        if ~isnan(trial(i).(taste{j}))
            trial(i).taste = trial(i).(taste{j})(1);
        end
    end
end
%%
cd([path,animalID,'\',date,'\1'])
% save('dataForCNMF.mat','trial','trial2','CC','jsf')

neuron_data = trial2neuron5tastant_2p(trial);
load('reject.mat')
reject = unique(reject);
neuron_data(reject)=[];
for i = 1:length(trial)
    trial(i).S_trace(reject,:) =[];
    trial(i).C_raw_trace(reject,:) =[];
end
neuron_data = stats_2p(trial,neuron_data);
% check each individual neuron
% i=15;
% psth_cue(trial,i)
% psth_taste(trial,i)
% psth_lick(trial,i)

CC(reject)   =[];
jsf(reject)  =[];

% imporse more strict criteria. check the overlap between cue and lick
% response
k=1;
for i = 1:length(neuron_data)
    if neuron_data(i).CueRes * neuron_data(i).LickRes ==1
        overlap_cueLick(k) =i;
        k = k+1;
    end
end
if exist('overlap_cueLick') ==1
    resp_cueLick = stats_1p_overlapCueLick(trial, overlap_cueLick);
    for i = 1:length(overlap_cueLick)
        neuron_data(overlap_cueLick(i)).LickRes = resp_cueLick(i).LickRes;
    end
end
% imporse more strict criteria. check the overlap between cue and lick
% response
k=1;
for i = 1:length(neuron_data)
    if neuron_data(i).S ==1 && neuron_data(i).N ==1 && neuron_data(i).CA ==1 && ...
            neuron_data(i).Q ==1 && neuron_data(i).W == 1 && neuron_data(i).LickRes == 1
        overlap_tasteLick(k) =i;
        k = k+1;
    elseif neuron_data(i).S ==-1 && neuron_data(i).N ==-1 && neuron_data(i).CA ==-1 && ...
            neuron_data(i).Q ==-1 && neuron_data(i).W == -1 && neuron_data(i).LickRes == -1
        overlap_tasteLick(k) =i;
        k = k+1;        
    end
end

if exist('overlap_tasteLick') == 1
    resp_tasteLick = stats_2p_overlapTasteLick(trial, overlap_tasteLick);
    
    for i = 1:length(overlap_tasteLick)
        neuron_data(overlap_tasteLick(i)).S =resp_tasteLick(i).S;
        neuron_data(overlap_tasteLick(i)).N =resp_tasteLick(i).N;
        neuron_data(overlap_tasteLick(i)).CA =resp_tasteLick(i).CA;
        neuron_data(overlap_tasteLick(i)).W =resp_tasteLick(i).W;
        neuron_data(overlap_tasteLick(i)).Q =resp_tasteLick(i).Q;
    end
end
%%
neuron.Cn = Cn;
Coor = CC;
cd([path,animalID,'\',date,'\1'])
if exist('SessionSummary')==7
    cd([path,animalID,'\',date,'\1\SessionSummary'])
    save(['summary_',animalID,'.mat'],'trial','neuron','neuron_data','Coor')
else
    mkdir('SessionSummary')
    cd([path,animalID,'\',date,'\1\SessionSummary'])
    save(['summary_',animalID,'.mat'],'trial','neuron','neuron_data','Coor')
end
% summary_1p(trial,neuron_data,neuron,Coor)





