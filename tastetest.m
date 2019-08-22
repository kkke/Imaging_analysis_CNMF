function resp = tastetest(neuron,trial)
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