function [taste_time, taste_response] = psth_taste_pop_2p(neuron_data,ind_taste)
taste_resp = neuron_data(ind_taste); % get all the taste response
id = {'S','N','CA','Q','W'};
resp = {'S_trace_dF','N_trace_dF','CA_trace_dF','Q_trace_dF','W_trace_dF'};
for i = 1:length(id)
    for j = 1:length(taste_resp)
        resp_amp = full(taste_resp(j).(resp{i}));
        
        temp_time = taste_resp(j).ts_frame.(id{i});
        
        for k = 1:size(temp_time,1)
            temp = min(find(temp_time(k,:)>0));
            temp_take(k,:) = temp-22:1:temp+21;
            if temp+21>60
                warning('Taste delivery very late; padding zeros')
                temp_resp_temp = resp_amp(k,temp_take(k,1):60);
                temp_resp(k,:) = [temp_resp_temp,zeros(1,temp_take(k,end)-60)]; % padding zeros
                temp_time_temp = temp_time(k,temp_take(k,1):60);
                temp_timenorm(k,:) = [temp_time_temp,temp_time_temp(end)+ mean(diff(temp_time_temp))*[1:1:temp_take(k,end)-60]];
            else
                temp_resp(k,:) = resp_amp(k,temp_take(k,:));
                temp_timenorm(k,:) = temp_time(k,temp_take(k,:));
            end
        end
        time.(id{i}) = mean(temp_timenorm,1);
        tasteid.(id{i})(j,:) = mean(temp_resp,1);
        clear resp_amp temp_time temp temp_take temp_resp temp_timenorm temp_resp_temp temp_time_temp
    end
end
taste_time = time;
taste_response = tasteid;