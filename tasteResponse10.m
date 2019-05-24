function resp = tasteResponse10(neuron,trial)
% stats for deconvolved data;
% here I use the 1 s before lick intiates as the baseline to test the lick
% response
%% taste response
% 1 s before taste delivery as baseline
t = 0.05;
rw = 3.5;
taste = {'S','M','CA','Q','W'};
tasteResponse = {'S_Taste_dF','M_Taste_dF','CA_Taste_dF','Q_Taste_dF','W_Taste_dF'};
data = neuron;
for j = 1:length(taste)
    for i = 1:length(data)
%         fprintf(num2str(i))
%         ind = find(data(i).framT>-1 & data(i).framT<0);  % choose [-2,-1]  as baseline; [-1,0] was used to calculate dF
%         ind = find(neuron(j).T>-1 & neuron(j).T <0);
        ind = find(neuron(j).T>-0.5 & neuron(j).T <0);
        baseline.(taste{j}) = data(i).(tasteResponse{j})(:,ind);
        m = mean(baseline.(taste{j}),2);
        indT = find(data(i).T>0 & data(i).T<3.5); % [0 3.5] after taste delivery was used to for stats
        tasteResAvg = data(i).(tasteResponse{j})(:,indT);
        [M, I] = max(tasteResAvg,[],2); % get the peak for each trial
        for z = 1:length(I) % loop through each trial
            if I(z)<=2; % the peak is the first two frames after the taste
                indTest(z,:) =indT(1:5);
            else
                indTest(z,:) = (I(z)-2+indT(1)-1):1:(I(z)+2 +indT(1)-1); % 5 frames around the peak
            end
            tasteTest(z,:) = data(i).(tasteResponse{j})(z,indTest(z,:)); % get 5 frames around the peak.
        end
        tasteTestavg = mean(tasteTest,2);
        
        [p,~] = ranksum(m,tasteTestavg);
        if p<0.05 && mean(tasteTestavg)>mean(m) % only test the excitatory response
            resp(i).(taste{j}) = 1;
        elseif p<0.05 && mean(tasteTestavg)<mean(m)
            resp(i).(taste{j}) = -1;
        else
            resp(i).(taste{j}) = 0;

        end
        clear indTest
    end
end
%% cue response with signed rank
clear p h
t = 0.01;
rw = 2;
[lickIni,~] = lickIniateTime(trial);

for j = 1:length(neuron)
    idx = find(neuron(1).framT>-1 & neuron(1).framT <0); % use [-2,-1] as the baseline
    C_idx1 = find(neuron(1).framT>0 & neuron(1).framT <2);
    baseline   = mean(neuron(j).trace_dF(:,idx),2);
%     C_1        = mean(neuron(j).trace_dF(:,C_idx1),2);
    C_1 = baselineExtract(neuron(j),lickIni,rw); % actually not baseline, but the tested period.

    C = C_1;
    [p,~] = ranksum(C,baseline);
    if p >=t
        h = 0;
    elseif p<t && mean(C)< mean(baseline)
        h = -1;
    elseif p<t && mean(C)> mean(baseline)
        h = 1;
    else
        h = 0;
        if isnan(p)
        else
            error('Something is wrong')
        end
    end
    resp(j).CueRes = h;
%     resp(j).cueP = p;
%     neuron(j).CueRes.h = sum(h);
%     neuron(j).TasteResponse = sum(h);
end
%% lick response with signed ranksum test
clear baseline C_1
t = 0.01;
% rw = 1;
for j = 1:length(neuron)
%     idx = find(trial(1).TLick>-1 & trial(1).TLick <0); % [-1,0] as the baseline
    idx = find(trial(1).TLick>-0.5 & trial(1).TLick <0); % [-0.5,0] as the baseline

%     C_idx1 = find(trial(1).TLick>0 & trial(1).TLick <rw);
    for i = 1:length(trial)
        baseline(i)   = mean(trial(i).LickTrace(j,idx),2);
%         C_1(i)        = mean(trial(i).LickTrace(j,C_idx1),2);
    end
    [C_1,rw] = lickTestPeriod(trial,lickIni,j);
    
    [c_p,~] = ranksum(C_1,baseline);
    if  c_p>=t
        c_h = 0;
    elseif c_p<t && mean(C_1)< mean(baseline)
        c_h = -1;
    elseif c_p<t && mean(C_1)> mean(baseline)
        c_h = 1;
    else
        c_h = 0;
        if isnan(c_p)
        else
            error('Something is wrong')
        end
    end

    resp(j).LickRes = c_h;

end

