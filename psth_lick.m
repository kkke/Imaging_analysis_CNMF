function psth_lick(trial,k)
[lickIni,~] = lickIniateTime(trial);
figure;
hold on
for i = 1:length(trial)
    time(i,:) = trial(i).Frame(1:124)-lickIni(i);
    cue_Sp(i,:) = trial(i).S_trace(k,1:124);
    plot(time(i,:),cue_Sp(i,:),'Color',[0.5,0.5,0.5,0.5])
end
plot(mean(time),mean(cue_Sp),'k')
xlim([-3,12])

clear time cue_Sp
figure;
hold on
for i = 1:length(trial)
    time(i,:) = trial(i).Frame(1:124)-lickIni(i);
    cue_Sp(i,:) = trial(i).C_raw_trace(k,1:124);
    plot(time(i,:),cue_Sp(i,:),'Color',[0.5,0.5,0.5,0.5])
end
plot(mean(time),mean(cue_Sp),'k')
xlim([-3,12])

