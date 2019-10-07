function [fakeneuron, neuron_new] = detectfake(neuron)
neuron_temp = neuron;

for i = 1:size(neuron_temp.C,1)
    loc = find(neuron_temp.C(i,:)>0.1);
    duration = diff(loc);
    event(i) = realevent(duration); % detect the event; need to at least 5 frame cross the threshold
end

k =1;

for i = 1:size(neuron_temp.C,1)
    if isempty(event(i).lickCount)
        fakeneuron(k) = i;
        k = k+1;
    end
end

neuron_temp.A(:, fakeneuron)=[];
neuron_temp.C(fakeneuron,:) =[];
neuron_temp.C_raw(fakeneuron,:)=[];
neuron_temp.S(fakeneuron,:) =[];
neuron_temp.ids(fakeneuron) =[];
neuron_temp.tags(fakeneuron) =[];
neuron_new = neuron_temp;

