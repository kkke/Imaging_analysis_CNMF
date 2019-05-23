% Imaging analysis for GC project
%% rigister your image
% segment your image with Segmentation_CaImAN
%% load imaging data and ROI
% clear
% animalID = 'RVKC377';
% date     = '180821';
function [trial, trial2,trial3] = imaging_analysis_GC_v6(animalID,date)
%%
path = 'F:\Imaging in GC\ImagingData\';
cd([path,animalID,'\',date,'\1\'])
file = 'data_CNMF.mat';
load(file)
% Fcell = F_dff;  % extract the neuron;
[CC,jsf,im] = plot_contours(A_keep,Cn,options,1);
close all
clearvars -except F_dff S_dec C_dec path date animalID CC jsf

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

[trial] = imaging_analysis_GC_v7(F_dff,trial,animalID,date);
[trial2] = imaging_analysis_GC_v7(S_dec,trial,animalID,date); 
[trial3] = imaging_analysis_GC_v7(C_dec,trial,animalID,date);
% [trial2] = imaging_analysis_GC_v8(S_dec,trial,animalID,date); % traces were not smoothed
% [trial3] = imaging_analysis_GC_v8(C_dec,trial,animalID,date); % traces were not smoothed

% field = {'S_trace_dF','M_trace_dF','CA_trace_dF','Q_trace_dF','W_trace_dF',...
%     'S_licks','M_licks','CA_licks','Q_licks','W_licks'};
% neuron = rmfield(neuron,field);
% neuron2 = rmfield(neuron2,field);
cd([path,animalID,'\',date,'\1'])
save('dataForCNMF_v2.mat','trial','trial2','trial3','CC','jsf')
