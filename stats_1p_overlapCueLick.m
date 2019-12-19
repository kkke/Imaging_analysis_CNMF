function resp = stats_1p_overlapCueLick(trial, overlap)

[lickIni,~] = lickIniateTime(trial);

%% lick response

if isempty(find(isnan(lickIni)))
else
    warning('Check here to add idx of no lick trials')
    idx_temp = find(isnan(lickIni));
    lickIni(idx_temp)=[]; % remove the trials that the lick is too close to the onset of tone
    trial(idx_temp)  =[];
end

for j = 1:length(overlap)
    for i = 1:length(lickIni) % for each trial; get the baseline
        temp = find(trial(i).Frame>lickIni(i)-0.5 & trial(i).Frame< lickIni(i)); % 0.5 s before lick as the baseline
        baseline(i) = mean(full(trial(i).S_trace(overlap(j),temp)));   
    end
    clear temp
    for i = 1:length(lickIni) % for each trial; get the test period
        if isempty(trial(i).taste) || lickIni(i)+1 <= trial(i).taste 
            temp = find(trial(i).Frame>lickIni(i) & trial(i).Frame <lickIni(i)+1); % test period 1 s afte lick
        else
            temp = find(trial(i).Frame>lickIni(i) & trial(i).Frame <trial(i).taste); % before taste delivery
        end
        
        test(i) = mean(full(trial(i).S_trace(overlap(j),temp))); % within 1s
        clear temp
    end
    
    [p,~] = ranksum(test,baseline);
    if p <0.05 && mean(test)>mean(baseline)
        h = 1;
    elseif p <0.05 && mean(test)<mean(baseline);
        h = -1;
    else
        h = 0;
    end
    resp(j).LickRes = h;
    clear baseline test p h
end

