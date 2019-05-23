function trial = lickRealign(trial,lickIni)

%% re-calculate or re-align the fram to the first licking bout
for i = 1:length(trial)
%     idx = find(trial(i).licks >1.9);
    trial(i).time_lick = trial(i).framT-lickIni(i);
end

for i = 1:length(trial)
    idx = find(trial(i).time_lick>-3 & trial(i).time_lick<4);  % should be 50
    if length(idx)==44
        trial(i).TLick = trial(i).time_lick(idx);
        trial(i).LickTrace = trial(i).traceSmooth_dF(:,idx);
    elseif length(idx) ==43
        idx(end+1) = idx(end)+1;
        trial(i).TLick = trial(i).time_lick(idx);
        trial(i).LickTrace = trial(i).traceSmooth_dF(:,idx);
    elseif length(idx) <43
                error('Something is wrong')
%         trial(i) =[];
    end
end
%%

