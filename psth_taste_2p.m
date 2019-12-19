function psth_taste_2p(temp,k)
taste = {'S','N','CA','Q','W'};
color = {'r','g','y','b','k'}
figure;
for j = 1:length(taste)

    for i = 1:size(temp(k).ts_frame.(taste{j}),1)
        resp_amp = temp(k).([taste{j},'_trace_dF']);
        time = temp(k).ts_frame.(taste{j});
        temp_idx = min(find(time(i,:)>0));
        temp_take(i,:) = temp_idx-22:1:temp_idx+21;
        if temp_idx+21>60
            warning('Taste delivery very late; padding zeros')
            temp_resp_temp = resp_amp(i,temp_take(i,1):60);
            temp_resp(i,:) = [temp_resp_temp,zeros(1,temp_take(i,end)-60)]; % padding zeros
            temp_time_temp = time(i,temp_take(i,1):60);
            temp_timenorm(i,:) = [temp_time_temp,temp_time_temp(end)+ mean(diff(temp_time_temp))*[1:1:temp_take(i,end)-60]];
        else
            temp_resp(i,:) = resp_amp(i,temp_take(i,:));
            temp_timenorm(i,:) = time(i,temp_take(i,:));
        end
        
    end
    subplot(2,1,1)
    hold on
    imagesc(mean(temp_timenorm),(1:size(temp_resp,1))+12*(j-1),temp_resp)
    xlim([-3.5,3.5])
    caxis([-0.2,0.8])
    subplot(2,1,2)
    hold on
    boundedline(mean(temp_timenorm),mean(temp_resp),std(temp_resp)/sqrt(size(temp_resp,1)),'alpha',color{j})
    xlim([-3.5,3.5])
    clear resp_amp time  temp_take temp_resp temp_timenorm
    
end