function neuron_data = getLickResp(trial, neuron_data)
t = 0.05;
rw = 2;
[lickIni,~] = lickIniateTime(trial);
iter =[];
for k = 1:length(lickIni) % reject trials with licking within 1 s of auditory cue
    if lickIni(k) < 1
        iter = [iter,k];
    end
end
lickIni(iter)=[]; % remove the trials that the lick is too close to the onset of tone
trial(iter)  =[];

if isempty(find(isnan(lickIni)))
else
    warning('Check here to add idx of no lick trials')
    idx_temp = find(isnan(lickIni));
    lickIni(idx_temp)=[]; % remove the trials that the lick is too close to the onset of tone
    trial(idx_temp)  =[];
end
for n = 1:size(trial(1).S_trace,1) % number of neurons
    for i = 1: length(lickIni)
            neuron_data(n).ts_frame.lickIni(i,:) = trial(i).Frame(1:124)-lickIni(i); % add 124 for 1p; for 2p, you do not need have it
            neuron_data(n).lick_trace_dF(i,:) = trial(i).C_raw_trace(n,1:124);   
    end
end