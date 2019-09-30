function summaryplot(datasave,sessions)
figure;
hold on
figure
plot([datasave.tasteRespCount]./[datasave.allCellCount],'-o')
hold on
plot([datasave.cueRespCount]./[datasave.allCellCount],'-o')
plot([datasave.lickRespCount]./[datasave.allCellCount],'-o')
hold off
xlim([0,4])
legend({'taste','cue','lick'})
ylim([0,0.25])
ylabel('Fraction of evoked response')
xlabel('Sessions')

figure;
hold on
for i =1:length(datasave)
   plot(datasave(i).tuning.res/datasave(i).tuning.all,'-o')
end
xlim([0,6])
ylim([0,0.5])
ylabel('Fraction of responsive neurons')
xlabel('Number of taste')
legend({'Session1', 'Session2','Session3'})
figure;
for i =1:length(datasave)
    subplot(1,3,i)
    venn(datasave(i).overlap.A,datasave(i).overlap.I)
    axis image
    title(['Session ', num2str(i)])
end
figure;
color = {'r','g','b'};
for i = 1:length(sessions)
    tasteResp.(sessions{i}).ap = [datasave(i).TasteResponse.ap.S; datasave(i).TasteResponse.ap.N; datasave(i).TasteResponse.ap.CA;...
        datasave(i).TasteResponse.ap.Q; datasave(i).TasteResponse.ap.W];
    tasteResp.(sessions{i}).time = [datasave(i).TasteResponse.time.S; datasave(i).TasteResponse.time.N; datasave(i).TasteResponse.time.CA;...
        datasave(i).TasteResponse.time.Q; datasave(i).TasteResponse.time.W];
    boundedline(mean(tasteResp.(sessions{i}).time),mean(tasteResp.(sessions{i}).ap),(std(tasteResp.(sessions{i}).ap))./sqrt(size(tasteResp.(sessions{i}).ap,1))','alpha',color{i})
end
xlabel('Time (s)')
ylabel('dF/F')
title('Taste evoked response')
xlim([-4,4])
ylim([-0.05,0.3])

figure;
for i = 1:length(sessions)
    boundedline(datasave(i).CueResponse.time.cue,mean(datasave(i).CueResponse.ap),(std(datasave(i).CueResponse.ap))./sqrt(size(datasave(i).CueResponse.ap,1))','alpha',color{i})
end
xlabel('Time (s)')
ylabel('dF/F')
title('Cue evoked response')
xlim([-2,6])
ylim([-0.05,0.3])

figure;
for i = 1:length(sessions)
    boundedline(datasave(i).LickResp.time,mean(datasave(i).LickResp.ap),(std(datasave(i).LickResp.ap))./sqrt(size(datasave(i).LickResp.ap,1))','alpha',color{i})
end
xlabel('Time (s)')
ylabel('dF/F')
title('Lick evoked response')
xlim([-3,4])
ylim([-0.1,0.35])