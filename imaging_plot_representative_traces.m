% plot representative traces for each trials 
% you need to load the summary file for that session
% for example: load('summary_RVKC403_date.mat')
neuron_id = [8,18,30]; % good representative neurons
trial_id  = 1:5;       % some trials
trial_id  = 6:10;
trial_id  = 11:15;
trial_id  = 2:6;
figure;
for i = 1:length(neuron_id)
    for j = 1:length(trial_id)
        plot(j*15+trial(trial_id(j)).Frame,i+trial(trial_id(j)).S_trace(neuron_id(i),:));        
        hold on
        plot(j*15+[0,0],i+[0,0.5],'--k')
        plot(j*15+trial(trial_id(j)).taste,i,'o','MarkerFaceColor','r')
        licks = trial(trial_id(j)).licks;
        licks = licks(find(licks>-2 & licks<7.5));
        for k = 1:length(licks)
            plot(j*15+[licks(k),licks(k)],i+[0,0.1],'-k')
        end
    end
    j = 1;
end
plot()