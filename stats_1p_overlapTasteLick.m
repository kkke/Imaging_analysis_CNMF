function resp = stats_1p_overlapTasteLick(trial,neuron, overlap)

%% Taste response
taste         = {'S', 'N', 'CA','Q','W'};
% thr = 3;
for j = 1:length(taste)
    for i = 1:length(overlap)
        kk = 1;
        for k = 1:length(trial)
            temp = trial(k).(taste{j});
            if ~isnan(temp) % find the trial index of the taste
                temp_taste(kk) = k;
                kk = kk +1;
            end
        end
        for kkk = 1:length(temp_taste)
            time_taste = trial(temp_taste(kkk)).(taste{j})(1);
            temp = find(trial(temp_taste(kkk)).Frame>time_taste-0.5 & trial(temp_taste(kkk)).Frame< time_taste); % [-0.5,0] before taste was used as baseline
            baseline(kkk) = mean(full(trial(temp_taste(kkk)).S_trace(overlap(i),temp)));
            temp_test = find(trial(temp_taste(kkk)).Frame>time_taste & trial(temp_taste(kkk)).Frame< time_taste+3.5); % [0 3.5] after taste delivery was used to for stats
            test = full(trial(temp_taste(kkk)).S_trace(overlap(i),temp_test));
            [M, I(kkk)] = max(test,[],2); % get the peak for each trial
            if I(kkk)<=4 % the peak is the first 4 frames after the taste
                indTest(kkk,:) =temp_test(1:9);
            else
                indTest(kkk,:) = (I(kkk)-4+temp_test(1)-1):1:(I(kkk)+4 +temp_test(1)-1); % 9 frames around the peak
            end
            tasteTest(kkk) = mean(full(trial(temp_taste(kkk)).S_trace(overlap(i),indTest(kkk,:)))); % get 9 frames around the peak.
        end
        [p,~] = ranksum(tasteTest,baseline);
        if p<0.05 && mean(tasteTest)>mean(baseline) % only test the excitatory response
            resp(i).(taste{j}) = 1;
        elseif p<0.05 && mean(tasteTest)<mean(baseline)
            resp(i).(taste{j}) = -1;
        else
            resp(i).(taste{j}) = 0;
        end
        clear tasteTest I temp_test time_taste baseline temp_taste
    end
end