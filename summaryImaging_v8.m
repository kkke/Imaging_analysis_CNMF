% %%
% clear
% % Load each Imaging data from Session 3
% file = {'RVKC368\180807','RVKC368\180809','RVKC368\180814','RVKC377\180828','RVKC402\181029','RVKC403\181029'...
%     ,'RVKC403\181030','RVKC403\181031','RVKC404\181119','RVKC405\181119','RVKC405\181120'};
function [all,neuron3] = summaryImaging_v8(file)
data2 = [];
neuron3 =[];
resp =[];
for j = 1:length(file)
    animalID = file{j}(1:7);
    date     = file{j}(9:end);
    cd(['F:\Imaging in GC\ImagingData\',file{j},'\1'])
    load('dataForCNMF.mat') 
    [trial2] = imaging_analysis_GC_v8(trial2); % added to remove the smooth for deconvolved activity
    neuron2 = trial2neuron5tastant_v2(trial2,animalID,date);
    neuron  = trial2neuron5tastant_v2(trial,animalID,date);
    load('reject.mat')
    reject = unique(reject);
%     resp3 = tasteResponse9(neuron2,trial2);
%     resp3 = tasteResponse3(neuron2,trial2);
    resp3 = TasteTestDev_v2(neuron2);
    data1 = resp3;
    data1(reject)=[];
    CC(reject)   =[];
    jsf(reject)  =[];
    neuron2(reject) =[];
    neuron(reject) =[];    
    field = {'trial','S_trace_dF','M_trace_dF','CA_trace_dF','Q_trace_dF','W_trace_dF',...
    'S_licks','M_licks','CA_licks','Q_licks','W_licks'};
    neuron = rmfield(neuron,field);
    neuron2= rmfield(neuron2,field);
    f = fieldnames(neuron);
    for m = 1:length(data1)
        for k = 1:length(f)
            data1(m).(f{k}) = neuron(m).(f{k});
        end
        data1(m).coordinates = CC{m};
        data1(m).centroid    = jsf(m).centroid;
    end
    clearvars -except data1 data2 neuron2 neuron3 file 
    data2 = [data2,data1];
    neuron3 = [neuron3,neuron2];
end
Session3 = data2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
all = Session3;
% cd('F:\Imaging in GC\Summary\summary3')
% save('all.mat','prop','cue','licknum','Taste','TasteRes','all')