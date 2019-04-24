% Imaging analysis for GC project
%% rigister your image
% segment your image with Segmentation_CaImAN
%% load imaging data and ROI
% clear
% animalID = 'RVKC377';
% date     = '180821';
function [trial] = imaging_analysis_GC_v8(trial);
%%
%% load the licking
%% Smooth the time-series with gaussian kerner
% do not smooth the deconvolved data
for i = 1:length(trial)
    for j = 1:size(trial(1).trace,1)
        trial(i).traceSmooth_dF(j,:) = trial(i).trace(j,:);
    end  
end

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
        trial(i).TLick = trial(i).time_lick(idx);
        trial(i).LickTrace = trial(i).traceSmooth_dF(:,idx);
    end 
end


