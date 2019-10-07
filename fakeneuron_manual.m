% mannully clear the fake neurons
function neuron_new = fakeneuron_manual(neuron)
file = dir('*.png');
file = struct2cell(file);
idx = cell(1,size(file,2));
for i = 1:length(file)
    idx{i} = file{1,i}(8:end-4);
end
idx = str2double(idx);
idx = sort(idx);
neuron_temp = neuron;
neuron_temp.A = neuron.A(:,idx);
neuron_temp.C =neuron.C(idx,:);
neuron_temp.C_raw =neuron.C_raw(idx,:);
neuron_temp.S =neuron.S(idx,:);
neuron_temp.ids =neuron.ids(idx);
neuron_temp.tags =neuron.tags(idx);
neuron_new = neuron_temp;