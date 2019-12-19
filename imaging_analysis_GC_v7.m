% Imaging analysis for GC project
%% rigister your image
% segment your image with Segmentation_CaImAN
%% load imaging data and ROI
% clear
% animalID = 'RVKC377';
% date     = '180821';
function [trial] = imaging_analysis_GC_v7(Fcell,trial,animalID,date);
%%
%% load the licking
% analog2 = SettingTwoPhoton('RVKC368_180731');
% for i = 1:length(analog2)
%     info(i) = analog2p_gc(analog2(i).data,1000);
% end
% %% check the signal
% figure
% for i = 1:3
%     subplot(1,3,i)
% %     plot(info(i).time, analog2(i).data(:,3));
%     plot(info(i).time, -analog2(i).data(:,2));
%     hold on
%     scatter(info(i).lick, 0.2*ones(size(info(i).lick)));
% end
%% correct the neuropil signal
Fcell_c = Fcell;
%% generate a trial structure; I know each trial contains 60 frames; and licking data are aligned to the tone;
% dF = reshape(full(Fcell), size(Fcell,1),60,[]);
dF = reshape(full(Fcell_c), size(Fcell_c,1),60,[]);

for i = 1:length(trial)
    trial(i).trace = dF(:,:,i);
end
%% get the timestamps of each frame after 5 time averaging
for i = 1:length(trial)
    idx = 3:5:300;
    trial(i).framT =trial(i).Frame(idx);
end
%% Smooth the time-series with gaussian kerner
for i = 1:length(trial)
    for j = 1:size(trial(1).trace,1)
        %         trial(i).traceSmooth_dF(j,:) = gaussmooth(trial(i).trace(j,:),5,1);
        trial(i).traceSmooth_dF(j,:) = trial(i).trace(j,:)';
    end
end
%% calculate the dF/F0; F0 is [-1 0] s before the tone
% for i = 1:length(trial)
%     idx = find(trial(1).framT>-1 & trial(1).framT<0);
%     baseline =mean(trial(i).traceSmooth(:,idx),2);
%     trial(i).traceSmooth_dF = (trial(i).traceSmooth-repmat(baseline,1,size(trial(i).traceSmooth,2)))./repmat(baseline,1,size(trial(i).traceSmooth,2));
% end
%% Plot Tone response
% for j =26:40
% n = j;
% figure;
% for i = 1: length(trial)
%     plot(trial(i).framT, trial(i).traceSmooth_dF(n,:),'Color',[0,0,0,0.5])
%     hold on
% end
% title(['Neuron # ', num2str(n)])
% xlim([-1.5,7])
% 
% end

%% align to the tastant
for i = 1:length(trial)
    if ~isnan(trial(i).S)
        trial(i).Time_Taste = trial(i).framT-trial(i).S(1);
    elseif ~isnan(trial(i).N)
        trial(i).Time_Taste = trial(i).framT-trial(i).N(1);
    elseif ~isnan(trial(i).CA)
        trial(i).Time_Taste = trial(i).framT-trial(i).CA(1);
    elseif ~isnan(trial(i).Q)
        trial(i).Time_Taste = trial(i).framT-trial(i).Q(1);
    elseif ~isnan(trial(i).W)
        trial(i).Time_Taste = trial(i).framT-trial(i).W(1);
    end
end
for i = 1:length(trial)
    idx = find(trial(i).Time_Taste>-4 & trial(i).Time_Taste<4);  % should be 50
    if length(idx)==50
        trial(i).T = trial(i).Time_Taste(idx);
        trial(i).Taste = trial(i).traceSmooth_dF(:,idx);
    elseif length(idx) ==49 && idx(end)+1 <=60
        idx(end+1) = idx(end)+1;
        trial(i).T = trial(i).Time_Taste(idx);
        trial(i).Taste = trial(i).traceSmooth_dF(:,idx);
    else
        trial(i).T = trial(i).Time_Taste(idx);
        trial(i).Taste = trial(i).traceSmooth_dF(:,idx);
    end 
end
%% pad zeros for trials with bin counts less than 50

emptyTrial =[];
for i = 1:length(trial)
    if length(trial(i).T) ==50
        T(i,:) = trial(i).T;
    else
        a = length(trial(i).T);
        if a ==0
            emptyTrial =[emptyTrial, i]; % trials without taste delivery
        else    
            for j = 1: (50-a)
                trial(i).T(a+j) = trial(i).T(a) + j * 0.161; % in case that there are less than  50 bin, I add more bins and pad the trace with 0;
                trial(i).Taste(:,a+j) = zeros(size(trial(1).Taste,1),1);
            end
        end
    end
end
% T = mean(T,1);
trial(emptyTrial) =[];

clear T
for i = 1:length(trial)
    T(i,:) = trial(i).T;
end
T = mean(T);
for i = 1:length(trial)
    trial(i).Tpro = T; % creat a proximate time for all tastant, as tastant may jitter a little bit.
end

%% stats for each tastant
%% statistical test
%%
% resp1 = tasteResponse(neuron);
%%
% plot_dF(10,neuron)

%% statistical test here the baseline is the 1 s before the cue; test cue response
%% check the cue respone
% plot_dF_cue(10,neuron)
%%
% save('data.mat','trial','Fcell','neuron','resp','dat','FcellNeu')
%% trying to extract the licking activity
% load('summary.mat') % summary.mat is saved be beha_2p
% plotLickIntan(summarydata)
% realign to the first lick after tone
for i = 1:length(trial)
    idx = find(trial(i).licks >1.9);
    trial(i).time_lick = trial(i).framT-trial(i).licks(idx(1));
end

for i = 1:length(trial)
    idx = find(trial(i).time_lick>-4 & trial(i).time_lick<4);  % should be 50
    if length(idx)==50
        trial(i).TLick = trial(i).time_lick(idx);
        trial(i).LickTrace = trial(i).traceSmooth_dF(:,idx);
    elseif length(idx) ==49
        idx(end+1) = idx(end)+1;
        if idx(end)+1>60 
        else
        trial(i).TLick = trial(i).time_lick(idx);
        trial(i).LickTrace = trial(i).traceSmooth_dF(:,idx);
        end
    end 
end

%% reorganize the data
% lickIni = lickIniateTime(trial);
% [C_1,rw,~] = lickTestPeriod(trial,lickIni,j);
% neuron = trial2neuron5tastant(trial,animalID,date);

%%
% for i = 1:length(trial)
%     if length(trial(i).TLick)==50
%         TLick(i,:) = trial(i).TLick;
%     else
%         error('Something is wrong')
%     end
% end
% 
% for i = 1:length(neuron)
%     neuron(i).TLick = mean(TLick,1);
%     for j = 1:length(trial)
%     neuron(i).Licktrace_dF(j,:) = trial(j).LickTrace(i,:);
%     end    
% end
%% statistical test here the baseline is the 1 s before the cue; test lick response
%% saptial location
