function psth_cue(trial,k)
figure;
hold on
t = 124; % 1p data
t = 60; % 2p data
for i = 1:length(trial)
    time(i,:) = trial(i).Frame(1:t);
    cue_Sp(i,:) = trial(i).S_trace(k,1:t);
    plot(time(i,:),cue_Sp(i,:),'Color',[0.5,0.5,0.5,0.5])
end
plot(mean(time),mean(cue_Sp),'k')
xlim([-3,12])

clear time cue_Sp
figure;
hold on
for i = 1:length(trial)
    time(i,:) = trial(i).Frame(1:t);
    cue_Sp(i,:) = trial(i).C_raw_trace(k,1:t);
    plot(time(i,:),cue_Sp(i,:),'Color',[0.5,0.5,0.5,0.5])
end
plot(mean(time),mean(cue_Sp),'k')
xlim([-3,12])

