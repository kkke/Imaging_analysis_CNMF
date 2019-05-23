%% summaryImaging_v2
clear
% Load each Imaging data from Session 1
file = {'RVKC368\180731','RVKC377\180821','RVKC402\181022','RVKC403\181022'...
    ,'RVKC404\181112','RVKC405\181112'};
all = summaryImaging_v4(file);
save('Session1.mat','all')

%%

clear
% Load each Imaging data from Session 2
file = {'RVKC368\180802','RVKC377\180823','RVKC402\181024','RVKC403\181024'...
    ,'RVKC404\181114','RVKC405\181114'};
all = summaryImaging_v4(file);
cd('F:\Imaging in GC\Summary\summary3')
save('Session2.mat','all')
%% Imaging_with CNMF
clear
% Load each Imaging data from Session 3
file = {'RVKC368\180807','RVKC377\180828','RVKC402\181029','RVKC403\181029'...
    ,'RVKC404\181119','RVKC405\181119'};
% all = summaryImaging_v4(file);
[all, neuron3] = summaryImaging_v6(file); % for deconvolution
cd('F:\Imaging in GC\Summary\summary4')
save('Session3_decon.mat','all','neuron3')

%% Imaging_with CNMF
clear
% Load each Imaging data from Session 3
file = {'RVKC368\180807','RVKC368\180809','RVKC368\180814','RVKC377\180828','RVKC402\181029','RVKC403\181029'...
    ,'RVKC403\181030','RVKC403\181031','RVKC404\181119','RVKC405\181119','RVKC405\181120'};
% Attention!!!!!!!!!!!!!!!! check the stats before run summaryImaging_v6.
[all, neuron3] = summaryImaging_v6(file); % for deconvolution: but for cue and lick

[Lickingpara] = summaryImaging_v9(file); % get the licking parameters
LickingPlots(Lickingpara)

save('LickingPara.mat','Lickingpara')
%
% [all, neuron3] = summaryImaging_v8(file); % for deconvolution; but for tastant response
cd('F:\Imaging in GC\Summary\summary5')
save('all_decon_newAlign_v2-2.mat','all','neuron3')
% save('all_decon_taste_v2.mat','all','neuron3')

% for j = 1:length(file)
%     cd(['F:\Imaging in GC\ImagingData\',file{j}])
%     load('data.mat')
%     data = resp3;
%     % plot the spatial map
%     ind = [dat.stat.iscell];
%     loc = dat.stat(find(ind ==1));
%     BW =zeros(512,512);
%     for i = 1:length(loc)
%         for z = 1:length(loc(i).xpix)
%             BW(loc(i).ypix(z), loc(i).xpix(z))=1;
%         end
%         [B{i},L{i}] = bwboundaries(BW,'noholes');
%         BW = zeros(512,512);
%     end
%     
% 
%     for i = 1:length(data)
%         data(i).animalID = neuron(i).animalID;
%         data(i).date     = neuron(i).date;
%         data(i).trace_dF = neuron(i).trace_dF;
%         data(i).S_trace_dF = neuron(i).S_trace_dF;
%         data(i).M_trace_dF = neuron(i).M_trace_dF;
%         data(i).CA_trace_dF = neuron(i).CA_trace_dF;
%         data(i).Q_trace_dF = neuron(i).Q_trace_dF;
%         data(i).W_trace_dF = neuron(i).W_trace_dF; 
%         data(i).framT = neuron(i).framT;
%         data(i).Licktrace_dF = neuron(i).Licktrace_dF;
%         data(i).TLick        = neuron(i).TLick; 
%         data(i).T = neuron(i).T;
%         data(i).S_Taste_dF = neuron(i).S_Taste_dF;
%         data(i).M_Taste_dF = neuron(i).M_Taste_dF;
%         data(i).CA_Taste_dF = neuron(i).CA_Taste_dF;
%         data(i).Q_Taste_dF = neuron(i).Q_Taste_dF;
%         data(i).W_Taste_dF = neuron(i).W_Taste_dF;
%         cor = B{i};
%         data(i).loc = cor{1};
%         [ cc, ~, ~ ] = polygeom(cor{1}(:,2), cor{1}(:,1));
%         data(i).cc       = [cc(2), cc(3)];
%     end
%     clearvars -except data data2 file
%     data2 = [data2,data];
% end
% Session3 = data2;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clearvars -except Session3
% cue = [Session3.CueRes];
% lick = [Session3.LickRes];
% prop.cue = sum(cue)./length(cue);
% licknum = find([Session3.CueRes]==0 & [Session3.LickRes] ==1);
% prop.lick = length(licknum)/length(Session3);
% for i = 1:length(Session3)
%     Taste(i).S = Session3(i).Sres;
%     Taste(i).M = Session3(i).Mres;
%     Taste(i).CA = Session3(i).CAres;
%     Taste(i).Q = Session3(i).Qres;
%     Taste(i).W = Session3(i).Wres;
% end
% 
% Taste = cell2mat(squeeze(struct2cell(Taste))');
% TasteRes = find(sum(Taste,2)>=1);
% TasteRes = setdiff(TasteRes,licknum);
% prop.taste = length(TasteRes)/length(Session3);
% all = Session3;
% cd('F:\Imaging in GC\Summary\summary3')
% save('all.mat','prop','cue','licknum','Taste','TasteRes','all')