%% scripts for cell registration across different sessions
%% load data
clear
animalID = 'RVKC402';
date     = {'181022','181024','181029'}
CellAlign_preprocess(animalID,date)
%%
clear
animalID = 'RVKC403';
date     = {'181022','181024','181029'}
CellAlign_preprocess(animalID,date)
%%
function CellAlign_preprocess(animalID,date)
% session  = {'s1','s2','s3'}
for ii = 1:length(date)
    cd(['F:\Imaging in GC\ImagingData\',animalID,'\',date{ii},'\1'])
    load('data_CNMF.mat')
    load('reject.mat')
    reject = unique(reject);
    A_keep(:,reject)=[];
    A_keep = full(A_keep);
    data_spatial(ii).spatial = A_keep;
    clearvars -except data_spatial animalID date
end
% re-organize the data
for i = 1:length(data_spatial)
    spatial = data_spatial(i).spatial';
    data_spatial(i).spatial = reshape(spatial,size(spatial,1),512,512);
end
% save the spatial information
cd(['F:\Imaging in GC\ImagingData\',animalID,'\'])
a = exist('RegistrationAcross')
if a ==7
else
    mkdir RegistrationAcross
end
cd(['F:\Imaging in GC\ImagingData\',animalID,'\','RegistrationAcross'])
for i = 1:length(data_spatial)
    spatial = data_spatial(i).spatial;
    save([animalID,'_',date{i},'_spatial.mat'],'spatial')
end
end