% taste = {'S','N','CA','Q','W'}; % calculate distance between taste
ind = [11,8,9,12,13];

for i = 1: length(ind)
    cd([data(ind(i)).disk,'\Imaging in GC\ImagingData\',data(ind(i)).animalID,'\',data(ind(i)).date,'\1\SessionSummary',])
    load(['summary_',data(ind(i)).animalID,'.mat'])
    f = {'S','N','CA','Q','W'};
    for k = 1:length(neuron_data)
        for j = 1:length(f)
            taste(k).(f{j}) = neuron_data(k).(f{j});
        end
    end
    taste = cell2mat(squeeze(struct2cell(taste)))';
    taste_all =taste(:,1:5);
    taste_all(find(taste_all ==-1))=0; % only analyze the excitatory response
    all_num = sum(taste_all,2); % get the evoked response
    evoke_ratio = length(find(all_num>0))/length(all_num);
    taste_num = sum(taste_all(:,1:5),2);
    ind_taste      = find(taste_num>0);
    tuning = taste_num(ind_taste);
    for k = 1:5
        res(k) = length(find(tuning ==k))
    end
    set_num(i).single = res(1)/length(ind_taste)
    set_num(i).single_count = res(1);
    set_num(i).total        = length(ind_taste);
%     for j = 1:length(taste)
%         set_num(i).(taste{j}) = find([neuron_data.(taste{j})]>=1);
%     end
clear taste
end

%%
single_sum = sum([set_num.single_count]);
total_sum  = sum([set_num.total]);
%% Let's see 1p data
ind = 3

