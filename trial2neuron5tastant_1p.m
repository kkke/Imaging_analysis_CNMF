%% this code is to reorganize the trial structure into neuron structure

function neuron_data = trial2neuron5tastant_1p(trial);
taste = {'S','N','CA','Q','W'};
for n = 1:size(trial(1).S_trace,1) % number of neurons
    
    for j = 1:length(taste)
        it = 1;
        for i = 1: length(trial)
            if ~isnan(trial(i).(taste{j}))
                neuron_data(n).ts_frame(it,:) = trial(i).Frame(1:124)-trial(i).(taste{j})(1);
                neuron_data(n).([taste{j},'_trace_dF'])(it,:) = trial(i).S_trace(n,1:124);
                %                 S_licks{it}    = trial(i).licks - trial(i).S(1);
                it =1+it;
            end
        end
    end
end





