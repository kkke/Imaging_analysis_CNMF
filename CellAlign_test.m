%% load data from session1
load('F:\Imaging in GC\ImagingData\RVKC402\181022\1\data_CNMF.mat')
load('reject.mat')
reject = unique(reject);
A_keep(:,reject)=[];
A1 = A_keep;
options1 = options;
options_mc1 = options_mc;
template1 = template;
%% load data from session2;
load('F:\Imaging in GC\ImagingData\RVKC402\181024\1data_CNMF.mat')
load('reject.mat')
reject = unique(reject);
A_keep(:,reject)=[];
A2 = A_keep;
options2 = options;
options_mc2 = options_mc;
template2 = template;
%% the results does not seems good
clearvars -except A1 A2 options1 options2 options_mc1 options_mc2 template1 template2
[matched_ROIs,nonmatched_1,nonmatched_2,A2,R,A_union] = register_ROIs(A1,A2,options1,template1,template2,options_mc1);
%%
A1 = A1';
A1 = full(A1);
A1 = reshape(A1,110,512,512);

A2 = A2';
A2 = full(A2);
A2 = reshape(A2,109,512,512);
%%
save('RVKC402-1.mat','A1');
save('RVKC402-2.mat','A2');
