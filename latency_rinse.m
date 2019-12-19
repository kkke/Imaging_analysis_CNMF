for i = 1:length(trial)
    if isempty(trial(i).licks)
        latency(i) = nan;
    else
        idx = min(find(trial(i).licks>10));
        if isempty(idx)
            latency(i) =nan;
        else
            latency(i) = trial(i).licks(idx);
        end
    end
end

taste = {'S','N','W','CA','Q'};
for j = 1:length(taste)
    for i = 1:length(trial)
        if ~isnan(trial(i).(taste{j}))
            if ~isempty(trial(i).(taste{j}))
                taste_d(i,j) = trial(i).(taste{j})(2);
            else
                taste_d(i,j) = nan;
            end
        else
            taste_d(i,j) = nan;
        end
    end
end

for i = 1:size(taste_d,2)
    idx = find(~isnan(taste_d(:,i)));
    taste_dd(idx) = taste_d(idx,i);
end
taste_dd(end+1)=0;
latency(isnan(latency))=0;
a = latency'-taste_dd;
a(a<=0)=[];