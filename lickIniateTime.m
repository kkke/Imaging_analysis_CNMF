function [lickIni bout_dur iti] = lickIniateTime(trial)
for i = 1:length(trial)
    clear bouts du
    tone = trial(i).tone;
    licks = trial(i).licks;
    licks = licks(find(licks>0 & licks<7.5));
    if isempty(licks)
        lickIni(i) = nan;
        bout_dur(i) = nan;
    else
        interLickinterval = diff(licks);
        temp = find(interLickinterval>=0.5);
        if isempty(temp)
            lickIni(i) = licks(1);
            bout_dur(i) = licks(end)-licks(1);
            iti(i)     = mean(licks);
        else
            for j=1:length(temp)
                if j==1;
                    bouts{1}=1:temp(1);
                else
                    bouts{j}=temp(j-1)+1:temp(j);
                end
            end
            bouts{j+1}=temp(j)+1:length(licks); % all the bouts including less than 3 licks
            lickSpont=[];
            % find out the bouts which has less than 3 licks
            for j=1:length(bouts)
                if length(bouts{j})<3
                    %             randlick=bouts{j};
                    bouts{j}=[];
                    %             lickSpont=[lickSpont randlick];
                end
            end
            bouts=bouts(~cellfun('isempty',bouts)); % all the real bouts       
            lickIni(i) = licks(min(bouts{1}));
            iti(i)     = mean(diff(licks(bouts{1})));
            if length(bouts)==1
                bout_dur(i) = licks(bouts{1}(end))-licks(bouts{1}(1));
            else
                for j = 1:length(bouts)
                    du(j) = licks(bouts{j}(end))-licks(bouts{j}(1));
                end
                bout_dur(i) = sum(du);
                clear du
            end
        end
    end
end