% analyze data just for one session
function summary_forSingleSession(file)
% summary_forSingleSession(files_path,file_names)
fprintf('Start summarizing data for one session...\n')
% file = 'RVKC402\181029';
% animalID = files_path(end-16:end-10);
% date     = files_path(end-8:end-3);
animalID = file(1:7);
date     = file(9:end);
files_path = ['G:\Imaging in GC\ImagingData\',animalID,'\',date,'\1']
file_names = 'dataForCNMF.mat'
cd(files_path)
load(file_names)
j = 1;
rm =[];
for i = 1:length(trial)
     if isempty(trial(i).TLick) % re trials which lick late
         rm(j) = i;
         j=j+1;
     end
end
if isempty(rm)
else
    trial(rm)=[];
    trial2(rm)=[];
    trial3(rm)=[];
    fprintf(num2str(rm))
end
[trial2] = imaging_analysis_GC_v8(trial2); % added to remove the smoothed deconvolution
neuron2 = trial2neuron5tastant_v2(trial2,animalID,date);
neuron  = trial2neuron5tastant_v2(trial,animalID,date);
resp1 = TasteTestDev_v2(neuron2); % for claculate the taste evoked response; baseline is 1 s before the tone
[lickIni,~] = lickIniateTime(trial); % calculate the lick initiation for each trial
iter =[];
for k = 1:length(lickIni) % reject trials with licking within 1 s of auditory cue
    if lickIni(k) < 1
        iter = [iter,k];
    end
end
lickIni(iter)=[]; % remove the trials that the lick is too close to the onset of tone
trial(iter)  =[];
trial2(iter) =[];
trial = lickRealign(trial,lickIni); % re-algin to the first lick bout
trial2= lickRealign(trial2,lickIni);
neuron2_2 = trial2neuron5tastant(trial2,animalID,date); % un-smoothed deconvolvement activity
neuron1_2 = trial2neuron5tastant(trial,animalID,date); % smoothed calcium traces

load('reject.mat')
reject = unique(reject);
resp3 = tasteResponse8(neuron2_2,trial2);  % use 1 s before tone as the baseline for cue and lick response
data1 = resp1; % get the taste response
for i = 1:length(data1)
    data1(i).CueRes = resp3(i).CueRes; % get the cue response
    data1(i).LickRes = resp3(i).LickRes; % get the lick response
end
data1(reject)=[];
CC(reject)   =[];
jsf(reject)  =[];
neuron2(reject) =[];
neuron(reject) =[];
neuron2_2(reject) =[];
neuron1_2(reject) =[];
field = {'trial','S_trace_dF','M_trace_dF','CA_trace_dF','Q_trace_dF','W_trace_dF',...
    'S_licks','M_licks','CA_licks','Q_licks','W_licks'};
neuron = rmfield(neuron,field);  % store un-convolved data
neuron2= rmfield(neuron2,field); % store deconvolved data
f = fieldnames(neuron);
for m = 1:length(data1)
    for k = 1:length(f)
        data1(m).(f{k}) = neuron(m).(f{k});
    end
    data1(m).coordinates = CC{m};
    data1(m).centroid    = jsf(m).centroid;
end
for i = 1:length(data1) % update data1 with the trace for cue and lick response (some trials were removed)
    data1(i).TLick    = neuron1_2(i).TLick;
    data1(i).trace_dF = neuron1_2(i).trace_dF;
    data1(i).Licktrace_dF = neuron1_2(i).Licktrace_dF;
    neuron2(i).trace_dF = neuron2_2(i).trace_dF;
    neuron2(i).Licktrace_dF  = neuron2_2(i).Licktrace_dF ;
end
% clearvars -except data1  neuron2 animalID date
mkdir SessionSummary
cd([files_path,'\SessionSummary'])
save(['summary','_',animalID,'_','date','.mat'],'data1', 'neuron2')
msgbox('Done')
