function [C_1,rw] = lickTestPeriod(trial,lickIni,m)
% calculate the response window for test lick response
f = {'S','N','W','CA','Q'};
for i = 1:length(trial)
    for j = 1:length(f)
        taste_trial.(f{j}) = trial(i).(f{j});
    end
    taste_trial = squeeze(struct2cell(taste_trial));
%     cellfun(@isnan,taste_trial,'UniformOutput',0)
    taste_trial(cellfun(@(taste_trial) any(isnan(taste_trial)),taste_trial)) = [];
    if isempty(taste_trial)
        rw(i) = 1;
    else
        taste_time = min(taste_trial{1});
        if taste_time-lickIni(i)>=1
            rw(i) = 1;
        else
            rw(i) = taste_time-lickIni(i);
        end
    end
    clear taste_trial
end

%%
for i = 1:length(trial)
    C_idx1 = find(trial(i).TLick>0 & trial(i).TLick <rw(i));
    C_1(i)        = mean(trial(i).LickTrace(m,C_idx1),2);
end
