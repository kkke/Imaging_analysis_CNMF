function [lick_time, lick_resp] = psth_lick_pop(trial,idx)
[lickIni,~] = lickIniateTime(trial);
% figure;
% hold on
for i = 1:length(trial)
    ts(i,:) = trial(i).Frame(1:124)-lickIni(i);
    temp = min(find(ts(i,:)>0));
    temp_idx(i,:) = temp-40:1:temp+60;
    temp_ts(i,:)  = ts(i,temp_idx(i,:));
    for j = 1:length(idx)
        lickresp(i,:,j) = full(trial(i).S_trace(idx(j),temp_idx(i,:)));
    end
end
lick_time = mean(temp_ts);
lick_resp = squeeze(mean(lickresp,1))';



% plot(mean(time),mean(cue_Sp),'k')
% xlim([-3,12])
% 
% clear time cue_Sp
% figure;
% hold on
% for i = 1:length(trial)
%     time(i,:) = trial(i).Frame(1:124)-lickIni(i);
%     cue_Sp(i,:) = trial(i).C_raw_trace(k,1:124);
%     plot(time(i,:),cue_Sp(i,:),'Color',[0.5,0.5,0.5,0.5])
% end
% plot(mean(time),mean(cue_Sp),'k')
% xlim([-3,12])

