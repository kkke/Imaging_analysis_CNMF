function [fakeneuron, neuron_new] = detectfake(neuron)

for i = 1:size(neuron.C,1)
    loc = find(neuron.C(i,:)>0.1);
    duration = diff(loc);
    event(i) = realevent(duration); % detect the event; need to at least 5 frame cross the threshold
end

k =1;

for i = 1:size(neuron.C,1)
    if isempty(event(i).lickCount)
        fakeneuron(k) = i;
        k = k+1;
    end
end

neuron.A(:, fakeneuron)=[];
neuron.C(fakeneuron,:) =[];
neuron.C_raw(fakeneuron,:)=[];
neuron.S(fakeneuron,:) =[];
neuron.ids(fakeneuron) =[];
neuron.tags(fakeneuron) =[];
neuron_new = neuron;

