function psth_lick(trial,k)
[lickIni,~] = lickIniateTime(trial);
% t = 124; % 1p
t = 60;    % 2p
% figure;
% hold on
% for i = 1:length(trial)
%     time(i,:) = trial(i).Frame(1:t)-lickIni(i);
%     cue_Sp(i,:) = trial(i).S_trace(k,1:t);
%     plot(time(i,:),cue_Sp(i,:),'Color',[0.5,0.5,0.5,0.5])
% end
% plot(mean(time),mean(cue_Sp),'k')
% xlim([-3,12])

clear time cue_Sp
figure;
% hold on
for i = 1:length(trial)
    time(i,:) = trial(i).Frame(1:t)-lickIni(i);
    cue_Sp(i,:) = trial(i).C_raw_trace(k,1:t);
    cue_Sp_s(i,:)=trial(i).S_trace(k,1:t);
%     plot(time(i,:),cue_Sp(i,:),'Color',[0.5,0.5,0.5,0.5])
end

% realing the data to the first lick
for i  = 1:length(trial)
    a = min(find(time(i,:)>0));
    time_realign(i,:) = time(i,a-12:a+24);
    cue_Sp_realign(i,:) = cue_Sp(i,a-12:a+24);
    cue_SpS_realign(i,:) = cue_Sp_s(i,a-12:a+24);
end
subplot(2,1,1)
imagesc(mean(time_realign), [],cue_Sp_realign)
caxis([-0.2,1.2])
xlim([-2,4])
% plot(mean(time),mean(cue_Sp),'k')
subplot(2,1,2)
boundedline(mean(time_realign),mean(cue_Sp_realign),std(cue_Sp_realign)./sqrt(size(cue_Sp_realign,1)),'alpha','k')
hold on
boundedline(mean(time_realign),mean(cue_SpS_realign),std(cue_SpS_realign)./sqrt(size(cue_SpS_realign,1)),'alpha','m')
ylim([-0.3,0.7])
xlim([-2,4])

