function neuron = stats_1p(trial,neuron)
%% Taste response 
taste         = {'S', 'N', 'CA','Q','W'};
% thr = 3;
for j = 1:length(taste)
    for i = 1:length(neuron)
        kk = 1;
        for k = 1:length(trial)
            temp = trial(k).(taste{j});
            if ~isnan(temp) % find the trial index of the taste
                temp_taste(kk) = k;
                kk = kk +1; 
            end
        end
        for kkk = 1:length(temp_taste)
            temp = find(trial(temp_taste(kkk)).Frame>-1 & trial(temp_taste(kkk)).Frame< 0); % [-1,0] was used as baseline
            baseline(kkk) = mean(full(trial(temp_taste(kkk)).S_trace(i,temp)));
            time_taste = trial(temp_taste(kkk)).(taste{j})(1);
            temp_test = find(trial(temp_taste(kkk)).Frame>time_taste & trial(temp_taste(kkk)).Frame< time_taste+3.5); % [0 3.5] after taste delivery was used to for stats
            test = full(trial(temp_taste(kkk)).S_trace(i,temp_test));
            [M, I(kkk)] = max(test,[],2); % get the peak for each trial
            if I(kkk)<=4 % the peak is the first 4 frames after the taste
                indTest(kkk,:) =temp_test(1:9);
            else
                indTest(kkk,:) = (I(kkk)-4+temp_test(1)-1):1:(I(kkk)+4 +temp_test(1)-1); % 9 frames around the peak
            end
            tasteTest(kkk) = mean(full(trial(temp_taste(kkk)).S_trace(i,indTest(kkk,:)))); % get 9 frames around the peak.
        end      
        [p,~] = ranksum(tasteTest,baseline);
        if p<0.05 && mean(tasteTest)>mean(baseline) % only test the excitatory response
            neuron(i).(taste{j}) = 1;
        elseif p<0.05 && mean(tasteTest)<mean(baseline)
            neuron(i).(taste{j}) = -1;
        else
            neuron(i).(taste{j}) = 0;
        end
        clear tasteTest I temp_test time_taste baseline temp_taste
    end
end


[lickIni bout_dur] = lickIniateTime(trial); % the the licking initiation and bout information

%% cue response with signed rank
clear p h
t = 0.05;
rw = 2;
[lickIni,~] = lickIniateTime(trial);
if isempty(find(isnan(lickIni)))
else
    error('Check here to add idx of no lick trials')
end

for j = 1:length(neuron)
    for i = 1:length(lickIni) % for each trial; get the baseline
        temp = find(trial(i).Frame>-1 & trial(i).Frame< 0); % 1 s before tone as the baseline
        baseline(i) = mean(full(trial(i).S_trace(j,temp)));   
    end
    clear temp
    for i = 1:length(lickIni) % for each trial; get the test period
        if lickIni(i)>=rw
            temp = find(trial(i).Frame>0 & trial(i).Frame <rw); % test period
        else
            temp = find(trial(i).Frame>0 & trial(i).Frame <lickIni(i));
        end
        temp_1s = find(trial(i).Frame>0 & trial(i).Frame <1);
        if temp(end)> temp_1s(end)
            test(1,i) = mean(full(trial(i).S_trace(j,temp_1s))); % within 1s
            test(2,i) = mean(full(trial(i).S_trace(j,setdiff(temp,temp_1s)))); % more than 1s
        else
            error('Check here to include more situations')
        end
        clear temp
    end
    
    [p1,~] = ranksum(test(1,:),baseline);
    [p2,~] = ranksum(test(2,:),baseline);
    if p1 >= t/2 && p2 >= t/2
        h = 0;
    elseif isnan(p1) && isnan(p2)
        if isequal(test(1,:),baseline) && isequal(test(2,:),baseline)
            h =0;
        else
        fprintf(num2str(j))
        error('Something is wrong')
        end
    elseif mean(test(1,:)) < mean(baseline) && mean(test(1,:))> mean(baseline)
        h = -1;
    elseif mean(test(1,:)) > mean(baseline) && mean(test(1,:))> mean(baseline)
        h = 1;
    else
        h = 2;
    end
    neuron(j).CueRes = h;
end
clear baseline test p h

%% lick response



