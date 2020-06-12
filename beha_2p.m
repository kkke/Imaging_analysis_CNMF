%% behaviral analysis for 2p rig
%% Step 1: load data from Intan
% clear
file = dir('*.rhd');
filename = file.name
data = read_Intan(filename);
[Frame,~] = Timing_onset_offset(data.event(7,:), data.ts, 0.5,10,0);
[Tone,~]  = Timing_onset_offset(data.event(6,:), data.ts, 0.5,100,0);
[W,~]     = Timing_onset_offset(data.event(5,:), data.ts, 0.5,10,0);
[Q,~]     = Timing_onset_offset(data.event(4,:), data.ts, 0.5,10,0);
[CA,~]    = Timing_onset_offset(data.event(3,:), data.ts, 0.5,10,0);
[N,~]     = Timing_onset_offset(data.event(2,:), data.ts, 0.5,10,0);
[S,~]     = Timing_onset_offset(data.event(1,:), data.ts, 0.5,10,0);
summarydata.filename = filename(1:end-4);
summarydata.Frame = Frame;
summarydata.Tone  = Tone;
summarydata.W     = W; % Line 5 is W
summarydata.Q     = Q; % Line 4 is Q
summarydata.CA    = CA; % Line 3 is CA
summarydata.N     = N; % line 2 is N
summarydata.S     = S; % Line1 is S;
summarydata.analog = data.analog;
summarydata.ts     = data.ts;
% clearvars -except summarydata;
%% check the licking signal
% figure;plot(summarydata.ts(1:500000),-summarydata.analog(1:500000)) % the licking signal is inverted, so i take the opposite value of it

% thr = input('Set the threshold')
[licks,~] = Timing_onset_offset(-summarydata.analog, summarydata.ts, -0.2,100,0);
summarydata.licks = licks;
% clearvars -except summarydata;
%%
% S  --> Line1;
% N  --> Line2;
% CA --> Line3; 
% Q  --> Line4; 
% W  --> Line5:
summarydata.W_ps      = summarydata.W(find(diff(summarydata.W)<1)); % there is an asummption here, the water event after tone shoul be very close, less than 1 s.
summarydata.S_ps      = summarydata.S(1:2:end); % there is an asummption here, there are also two consecutive event, take the first event;
summarydata.N_ps      = summarydata.N(1:2:end);
summarydata.CA_ps      = summarydata.CA(1:2:end);
summarydata.Q_ps      = summarydata.Q(1:2:end);
%% trying to extract which trial deliver which tastant
% L1 = [ones(size(summarydata.S_ps));summarydata.S_ps];
% L2 = [2*ones(size(summarydata.N_ps));summarydata.N_ps];
% L3 = [3*ones(size(summarydata.CA_ps));summarydata.CA_ps];
% L4 = [4*ones(size(summarydata.Q_ps));summarydata.Q_ps];
% L5 = [5*ones(size(summarydata.W_ps));summarydata.W_ps];
% L = [L1, L2, L3, L4, L5];
% [~,I] = sort(L(2,:));
% L_trial = L(:,I);
% save('summary.mat','summarydata')
% %% plot licking raster based on trial sequence
Tone_lick = spike2eventRasteandPSTH_NP (summarydata.licks,summarydata.Tone, 100, -2000, 8000);
% figure;
% subplot(2,1,1)
% 
% for i = 1:length(Tone_lick.spikeraster)
%     if ~isempty(Tone_lick.spikeraster(i))
%         id = L_trial(1,find(L_trial(2,:)>summarydata.Tone(i) & L_trial(2,:)<summarydata.Tone(i)+5));
%         if ~isempty(id)
%             switch id
%                 case 1
%                     scatter(Tone_lick.spikeraster(i).times,i*ones(size(Tone_lick.spikeraster(i).times)),6,'cv','filled');
%                 case 2
%                     scatter(Tone_lick.spikeraster(i).times,i*ones(size(Tone_lick.spikeraster(i).times)),6,'mv','filled');
%                 case 3
%                     scatter(Tone_lick.spikeraster(i).times,i*ones(size(Tone_lick.spikeraster(i).times)),6,'bv','filled')
%                 case 4
%                     scatter(Tone_lick.spikeraster(i).times,i*ones(size(Tone_lick.spikeraster(i).times)),6,'rv','filled')
%                 case 5
%                     scatter(Tone_lick.spikeraster(i).times,i*ones(size(Tone_lick.spikeraster(i).times)),6,'kv','filled')
%             end
%         end
%         
%         hold on
%     end
% end
% rectangle('Position',[0,0,2,i],'FaceColor',[0.5 .5 .5,0.5],'EdgeColor',[0.5 .5 .5,0])
% xlim([-2,8])
% xlabel('Time (s)')
% ylabel('Trial #')
% set(gca,'TickDir','out');
% 
% subplot(2,1,2)
% plot(Tone_lick.timepoint,Tone_lick.FR_avg,'r')
% rectangle('Position',[0,0,2,max(Tone_lick.FR_avg)],'FaceColor',[0.5 .5 .5,0.5],'EdgeColor',[0.5 .5 .5,0])
% xlim([-2,8])
% xlabel('Time (s)')
% ylabel('Lick Rate (Hz)')
% set(gca,'TickDir','out')
% box off

%% plot the licking raster based on different tastant
figure
f = {'S_ps', 'N_ps', 'CA_ps', 'Q_ps', 'W_ps'};
color = {'c','m','g','b','k'}

k = 1;
for j = 1: length(f)
    for i = 1:length(summarydata.(f{j}))
        id = find(summarydata.Tone<summarydata.(f{j})(i) & summarydata.Tone>summarydata.(f{j})(i)-5);
        if ~isempty(id)
            h1 = scatter(Tone_lick.spikeraster(id).times,k*ones(size(Tone_lick.spikeraster(id).times)),6,[color{j},'v'],'filled');
%             iti.s{i} = diff(Tone_lick.spikeraster(id).times);
        end
        k = k+1
        hold on
    end
end
xlim([-2, 8])
xlabel('Time (s)')
% for j = 1:length(summarydata.N_ps)
%     id = find(summarydata.Tone<summarydata.N_ps(j) & summarydata.Tone>summarydata.N_ps(j)-5);
%     i = i+1;
%     if ~isempty(id)
%         h2 = scatter(Tone_lick.spikeraster(id).times,i*ones(size(Tone_lick.spikeraster(id).times)),6,'mv','filled');
%         iti.n{j} = diff(Tone_lick.spikeraster(id).times);
%     end   
% end
% for j = 1:length(summarydata.CA_ps)
%     id = find(summarydata.Tone<summarydata.CA_ps(j) & summarydata.Tone>summarydata.CA_ps(j)-5);
%     i = i+1;
%     if ~isempty(id)
%         h3 = scatter(Tone_lick.spikeraster(id).times,i*ones(size(Tone_lick.spikeraster(id).times)),6,'bv','filled');
%         iti.c{j} = diff(Tone_lick.spikeraster(id).times);
%     end   
% end
% for j = 1:length(summarydata.Q_ps)
%     id = find(summarydata.Tone<summarydata.Q_ps(j) & summarydata.Tone>summarydata.Q_ps(j)-5);
%     i = i+1;
%     if ~isempty(id)
%         h4 = scatter(Tone_lick.spikeraster(id).times,i*ones(size(Tone_lick.spikeraster(id).times)),6,'rv','filled');
%         iti.q{j} = diff(Tone_lick.spikeraster(id).times);
%     end   
% end
% for j = 1:length(summarydata.W_ps)
%     id = find(summarydata.Tone<summarydata.W_ps(j) & summarydata.Tone>summarydata.W_ps(j)-5);
%     i = i+1;
%     if ~isempty(id)
%         h5 = scatter(Tone_lick.spikeraster(id).times,i*ones(size(Tone_lick.spikeraster(id).times)),6,'kv','filled');
%         iti.w{j} = diff(Tone_lick.spikeraster(id).times);
%     end   
% end
% legend([h1,h2,h3,h4,h5],{'S','N','C','Q','W'})
% rectangle('Position',[0,0,2,i],'FaceColor',[0.5 .5 .5,0.5],'EdgeColor',[0.5 .5 .5,0])
% xlim([-2,8])
% xlabel('Time (s)')
% ylabel('Trial #')
% set(gca,'TickDir','out');
%%
% iti_s = cell2mat(iti.s);
% iti_n = cell2mat(iti.n);
% iti_c = cell2mat(iti.c);
% iti_q = cell2mat(iti.q);
% iti_w = cell2mat(iti.w);
% 
% figure;
% [h1,x1] = ecdf(iti_s(find(iti_s<0.5)));
% hold on
% [h2,x2] = ecdf(iti_n(find(iti_n<0.5)));
% [h3,x3] = ecdf(iti_c(find(iti_c<0.5)));
% [h4,x4]= ecdf(iti_q(find(iti_q<0.5)));
% [h5,x5]= ecdf(iti_w(find(iti_w<0.5)));
% 
% plot(x1,h1,'c')
% hold on
% plot(x2,h2,'m')
% plot(x3,h3,'b')
% plot(x4,h4,'r')
% plot(x5,h5,'k')
% xlabel('Inter-lick interval (s)')
% ylabel('Cumulative proportion')
%%
% t =1;
% figure
% lick_S = spike2eventRasteandPSTH_NP (summarydata.licks,summarydata.S_ps, 100, -3000, 5000);
% for j = 1:length(summarydata.S_ps)
%     if ~isempty(lick_S.spikeraster(j).times)
%         h1 = scatter(lick_S.spikeraster(j).times,j*ones(size(lick_S.spikeraster(j).times)),6,'cv','filled');
%         idx = find(lick_S.spikeraster(j).times>0 & lick_S.spikeraster(j).times<=t);       
%         lickrate.s{j} = diff(lick_S.spikeraster(j).times(idx));
%         hold on
%     end
% end
% i = j;
% lick_N = spike2eventRasteandPSTH_NP (summarydata.licks,summarydata.N_ps, 100, -3000, 5000);
% for j = 1:length(summarydata.N_ps)
%     i = i+1;
%     if ~isempty(lick_N.spikeraster(j).times)
%         h1 = scatter(lick_N.spikeraster(j).times,i*ones(size(lick_N.spikeraster(j).times)),6,'mv','filled');
%         idx = find(lick_N.spikeraster(j).times>0 & lick_N.spikeraster(j).times<=t);
%         lickrate.n{j} = diff(lick_N.spikeraster(j).times(idx));
%         hold on
%     end
% end

% lick_C = spike2eventRasteandPSTH_NP (summarydata.licks,summarydata.CA_ps, 100, -3000, 5000);
% for j = 1:length(summarydata.CA_ps)
%     i = i+1;
%     if ~isempty(lick_C.spikeraster(j).times)
%         h1 = scatter(lick_C.spikeraster(j).times,i*ones(size(lick_C.spikeraster(j).times)),6,'bv','filled');
%         idx = find(lick_C.spikeraster(j).times>0 & lick_C.spikeraster(j).times<=t);
%         lickrate.c{j} = diff(lick_C.spikeraster(j).times(idx));
%         hold on
%     end
% end

% lick_Q = spike2eventRasteandPSTH_NP (summarydata.licks,summarydata.Q_ps, 100, -3000, 5000);
% for j = 1:length(summarydata.Q_ps)
%     i = i+1;
%     if ~isempty(lick_Q.spikeraster(j).times)
%         h1 = scatter(lick_Q.spikeraster(j).times,i*ones(size(lick_Q.spikeraster(j).times)),6,'rv','filled');
%         idx = find(lick_Q.spikeraster(j).times>0 & lick_Q.spikeraster(j).times<=t);
%         lickrate.q{j} = diff(lick_Q.spikeraster(j).times(idx));
%         hold on
%     end
% end

% lick_W = spike2eventRasteandPSTH_NP (summarydata.licks,summarydata.W_ps, 100, -3000, 5000);
% for j = 1:length(summarydata.W_ps)
%     i = i+1;
%     if ~isempty(lick_W.spikeraster(j).times)
%         h1 = scatter(lick_W.spikeraster(j).times,i*ones(size(lick_W.spikeraster(j).times)),6,'kv','filled');
%         idx = find(lick_W.spikeraster(j).times>0 & lick_W.spikeraster(j).times<=t);
%         lickrate.w{j} = diff(lick_W.spikeraster(j).times(idx));
%         hold on
%     end
% end
% 
% xlabel('Time (s)')
% ylabel('Trial #')
% xlim([-3,5])
%%
% lickrate_s = cell2mat(lickrate.s);
% lickrate_n = cell2mat(lickrate.n);
% lickrate_c = cell2mat(lickrate.c);
% lickrate_q = cell2mat(lickrate.q);
% lickrate_w = cell2mat(lickrate.w);
% 
% lickrate_avg = 1/mean([lickrate_s,lickrate_n,lickrate_c,lickrate_q]);
%%
% t =1;
% figure
% for j = 1:length(summarydata.S_ps)
%     if ~isempty(lick_S.spikeraster(j).times)
%         id = find(lick_S.spikeraster(j).times>0);
%         t1 = id(1);
%         h1 = scatter(lick_S.spikeraster(j).times-lick_S.spikeraster(j).times(t1),j*ones(size(lick_S.spikeraster(j).times)),6,'cv','filled');
%         idx = find(lick_S.spikeraster(j).times>0 & lick_S.spikeraster(j).times<=t);       
%         lickrate.s{j} = diff(lick_S.spikeraster(j).times(idx));
%         hold on
%     end
% end
% i = j;
% lick_N = spike2eventRasteandPSTH_NP (summarydata.licks,summarydata.N_ps, 100, -3000, 5000);
% for j = 1:length(summarydata.N_ps)
%     i = i+1;
%     if ~isempty(lick_N.spikeraster(j).times)
%         id = find(lick_N.spikeraster(j).times>0);
%         t1 = id(1);
%         h1 = scatter(lick_N.spikeraster(j).times-lick_N.spikeraster(j).times(t1),i*ones(size(lick_N.spikeraster(j).times)),6,'mv','filled');
%         idx = find(lick_N.spikeraster(j).times>0 & lick_N.spikeraster(j).times<=t);
%         lickrate.n{j} = diff(lick_N.spikeraster(j).times(idx));
%         hold on
%     end
% end

% lick_C = spike2eventRasteandPSTH_NP (summarydata.licks,summarydata.CA_ps, 100, -3000, 5000);
% for j = 1:length(summarydata.CA_ps)
%     i = i+1;
%     if ~isempty(lick_C.spikeraster(j).times)
%         id = find(lick_C.spikeraster(j).times>0);
%         t1 = id(1);
%         h1 = scatter(lick_C.spikeraster(j).times-lick_C.spikeraster(j).times(t1),i*ones(size(lick_C.spikeraster(j).times)),6,'bv','filled');
%         idx = find(lick_C.spikeraster(j).times>0 & lick_C.spikeraster(j).times<=t);
%         lickrate.c{j} = diff(lick_C.spikeraster(j).times(idx));
%         hold on
%     end
% end

% lick_Q = spike2eventRasteandPSTH_NP (summarydata.licks,summarydata.Q_ps, 100, -3000, 5000);
% for j = 1:length(summarydata.Q_ps)
%     i = i+1;
%     if ~isempty(lick_Q.spikeraster(j).times)
%         id = find(lick_Q.spikeraster(j).times>0);
%         t1 = id(1);
%         h1 = scatter(lick_Q.spikeraster(j).times-lick_Q.spikeraster(j).times(t1),i*ones(size(lick_Q.spikeraster(j).times)),6,'rv','filled');
%         idx = find(lick_Q.spikeraster(j).times>0 & lick_Q.spikeraster(j).times<=t);
%         lickrate.q{j} = diff(lick_Q.spikeraster(j).times(idx));
%         hold on
%     end
% end

% lick_W = spike2eventRasteandPSTH_NP (summarydata.licks,summarydata.W_ps, 100, -3000, 5000);
% for j = 1:length(summarydata.W_ps)
%     i = i+1;
%     if ~isempty(lick_W.spikeraster(j).times)
%         id = find(lick_W.spikeraster(j).times>0);
%         t1 = id(1);
%         h1 = scatter(lick_W.spikeraster(j).times-lick_W.spikeraster(j).times(t1),i*ones(size(lick_W.spikeraster(j).times)),6,'kv','filled');
%         idx = find(lick_W.spikeraster(j).times>0 & lick_W.spikeraster(j).times<=t);
%         lickrate.w{j} = diff(lick_W.spikeraster(j).times(idx));
%         hold on
%     end
% end
% figure;
% [h1,x1] = ecdf(lickrate_s);
% hold on
% [h2,x2] = ecdf(lickrate_n);
% [h3,x3] = ecdf(lickrate_c);
% [h4,x4]= ecdf(lickrate_q);
% [h5,x5]= ecdf(lickrate_w);
% 
% plot(x1,h1,'c')
% hold on
% plot(x2,h2,'m')
% plot(x3,h3,'b')
% plot(x4,h4,'r')
% plot(x5,h5,'k')

%%
% save('summary.mat','summarydata','lickrate_avg')
