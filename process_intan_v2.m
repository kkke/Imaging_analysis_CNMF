%% process data recorded from Intan board
function [data,trial] = process_intan_v2(filename);

data = read_Intan(filename);
% data = read_intan_batch;
%% extract the event data
[Frame,~] = Timing_onset_offset(data.event(7,:), data.ts, 0.5,10,0);
[Tone,~]  = Timing_onset_offset(data.event(6,:), data.ts, 0.5,10,0);
[W,~]     = Timing_onset_offset(data.event(5,:), data.ts, 0.5,10,0);
[Q,~]     = Timing_onset_offset(data.event(4,:), data.ts, 0.5,10,0);
[CA,~]    = Timing_onset_offset(data.event(3,:), data.ts, 0.5,10,0);
[N,~]     = Timing_onset_offset(data.event(2,:), data.ts, 0.5,10,0);
[S,~]     = Timing_onset_offset(data.event(1,:), data.ts, 0.5,10,0);
[licks,~] = Timing_onset_offset(-data.analog(1,:), data.ts, -0.2,100,1);
% close all
%% re-organize the data in a trial format
unit  = spike2eventRasteandPSTH_NP(Frame,Tone,100,-3000,12000);
unit2 = spike2eventRasteandPSTH_NP(S,Tone,100,-3000,12000);
unit3 = spike2eventRasteandPSTH_NP(N,Tone,100,-3000,12000);
unit4 = spike2eventRasteandPSTH_NP(W,Tone,100,-3000,12000);
unit5 = spike2eventRasteandPSTH_NP(CA,Tone,100,-3000,12000);
unit6 = spike2eventRasteandPSTH_NP(Q,Tone,100,-3000,12000);
unit7 = spike2eventRasteandPSTH_NP(licks,Tone,100,-3000,12000);


for i = 1:length(Tone)
    trial(i).tone = Tone(i);
    trial(i).Frame = unit.spikeraster(i).times;
    if ~isempty(unit2.spikeraster(i).times)
        trial(i).S = unit2.spikeraster(i).times;
        trial(i).N = NaN; % the trial of Line2 and Line1 alternates
        trial(i).W = NaN;
        trial(i).CA = NaN;
        trial(i).Q  = NaN;
    elseif ~isempty(unit3.spikeraster(i).times)
        trial(i).S = NaN;
        trial(i).N = unit3.spikeraster(i).times;
        trial(i).W = NaN;
        trial(i).CA = NaN;
        trial(i).Q  = NaN;
    elseif ~isempty(unit5.spikeraster(i).times)
        trial(i).S = NaN;
        trial(i).N = NaN;
        trial(i).W = NaN;
        trial(i).CA = unit5.spikeraster(i).times;
        trial(i).Q = NaN;
    elseif ~isempty(unit6.spikeraster(i).times)
        trial(i).S = NaN;
        trial(i).N = NaN;
        trial(i).W = NaN;
        trial(i).CA = NaN;
        trial(i).Q = unit6.spikeraster(i).times;        
    else
        trial(i).S = NaN;
        trial(i).N = NaN;
        trial(i).W = unit4.spikeraster(i).times;
        trial(i).CA = NaN;
        trial(i).Q  = NaN;   
    end
end

for i = 1:length(Tone)
    if ~isempty(unit7.spikeraster(i).times)
      trial(i).licks = unit7.spikeraster(i).times; 
    end
end
%% load the data from scope
% a             = textread('RVKC340_051218.txt');
% [licks,~]     = Timing_onset_offset(a(:,4), a(:,1), -0.22,30,1);
% [paw,~]       = Timing_onset_offset(a(:,4), a(:,1), -0.02,30,1);
% [Tone_sco,~]  = Timing_onset_offset(a(:,2), a(:,1), 2,30,1);
% licks         = setdiff(licks,paw);
% unit2 = spike2eventRasteandPSTH_NP(licks,Tone_sco,100,-2000,12000);
%%
% figure
% for i = 1:length(Tone)
%     if ~isempty(unit.spikeraster(i).times)
%         scatter(unit.spikeraster(i).times,i*ones(size(unit.spikeraster(i).times)),'r+')
%         hold on
%     end
%     if ~isempty(unit2.spikeraster(i).times)
%         scatter(unit2.spikeraster(i).times,i*ones(size(unit2.spikeraster(i).times)),6,'kv','filled')
%         hold on
%     end
% end
% xlim([-2,12])