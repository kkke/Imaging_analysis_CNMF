function neuron_data = trial2neuron5tastant_2p_v2(neuron_data,trial)
neuron_data_temp = trial2neuron5tastant_2p(trial);
% neuron_data_temp = trial2neuron5tastant_1p(trial);

f = fieldnames(neuron_data_temp);
for i = 1:length(f)
    for j = 1:length(neuron_data)
        neuron_data(j).(f{i}) = neuron_data_temp(j).(f{i});
    end
end
