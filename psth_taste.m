function psth_taste(trial,k)
taste = {'S','N','CA','Q','W'};
color = {'r','g','y','b','k'}
for j = 1:length(taste)
    figure;
    hold on
    for i = 1:length(trial)
        time(i,:) = trial(i).Frame(1:124)-trial(i).(taste{j})(1);
        cue_Sp(i,:) = trial(i).S_trace(k,1:124);
        plot(time(i,:),cue_Sp(i,:),'Color',[0.5,0.5,0.5,0.5])
    end
%     plot(mean(time),mean(cue_Sp),'k')
    xlim([-5,10])
    
    clear time cue_Sp
    figure;
    hold on
    for i = 1:length(trial)
        time(i,:) = trial(i).Frame(1:124)-trial(i).(taste{j})(1);
        cue_Sp(i,:) = trial(i).C_raw_trace(k,1:124);
        plot(time(i,:),cue_Sp(i,:),'Color',[0.5,0.5,0.5,0.5])
    end
    plot(mean(time),mean(cue_Sp),'k')
    xlim([-5,10])
end

