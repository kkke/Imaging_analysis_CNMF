%% representative cue responses
load('allImaging2p_C_raw.mat')
i = 306; % representative cue response
figure;
subplot(2,1,1)
imagesc(time,[],C_trace)
caxis([-0.2,1.2])
xlim([-1.5,4.5])
axis on
subplot(2,1,2)
C_trace = temp(i).C_raw_trace;
S_trace = temp(i).S_trace;
time    = mean(temp(i).framT);
boundedline(time,mean(C_trace),std(C_trace)./sqrt(size(C_trace,1)),'alpha','-r')
hold on
boundedline(time,mean(S_trace),std(S_trace)./sqrt(size(S_trace,1)),'alpha','-m')
xlim([-1.5,4.5])

%% representative lick responses
load('lastImagingSession_2p_clean.mat')
i =4;
cd([data(i).disk,'\Imaging in GC\ImagingData\',data(i).animalID,'\',data(i).date,'\1\SessionSummary'])
load(['summary_',data(i).animalID,'.mat'])
idx = find([neuron_data.LickRes]>=1);
for j = 1:length(idx)
%     figure;
%     resp = temp(idx(i)).C_raw_trace;
% %     resp = temp(idx(i)).S_trace;
%     sem = std(resp)./sqrt(size(resp,1));
%     boundedline(mean(temp(idx(i)).framT),mean(resp),sem','alpha','k')
%     xlim([-1.5,4.5])
psth_lick(trial,idx(j))
end
%% representative taste responses
taste = {'S', 'N','CA','Q','W'};
for i = 1:length(taste)
    for j = 1:length(temp)
        temp_t(j,i) = temp(j).(taste{i});
    end
end
temp_t(temp_t==-1)=0;
idx = find(sum(temp_t,2)>0);
example = [1,6,14,20,23,30,31,35,98,157,158,161,184,208,216,217,218,221,223,226,229,230,263,264,265];
for i = 1:length(example)    % i =1,6,14,20,23,30,31,35,98,157,158,161,184,208,-216-,217,218,221,223,226,229,230,263,264,265,
    psth_taste_2p(temp,idx(example(i)))
end


