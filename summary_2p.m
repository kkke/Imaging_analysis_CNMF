function summary_2p(neuron_data)
clear taste
f = {'S','N','CA','Q','W','CueRes','LickRes'};
for i = 1:length(neuron_data)
    for j = 1:length(f)
        taste(i).(f{j}) = neuron_data(i).(f{j});
    end
end

%% Find the cue response, lick response and taste response
taste = cell2mat(squeeze(struct2cell(taste)))';
taste_all =taste(:,1:5);
taste_all(find(taste_all ==-1))=0; % only analyze the excitatory response
all_num = sum(taste_all,2); % get the evoked response
evoke_ratio = length(find(all_num>0))/length(all_num);
taste_num = sum(taste_all(:,1:5),2);
ind_taste      = find(taste_num>0);
ind_cue  = [find(taste(:,6)==1); find(taste(:,6)==2)]; % cue response
ind_lick = find(taste(:,7)==1); % lick response
lick_taste= intersect(ind_taste,ind_lick); % starts to clarify the lick response and taste response
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cue_lick  = intersect(ind_cue,ind_lick); % start to clarify the cue response and lick response
cue_taste = intersect(ind_cue,ind_taste);
%% do some plotting
figure;
bar(sum(taste_all)./size(ind_taste,1))
tasteLabel = {'S','N','CA','Q','W'};
set(gca,'xticklabel',tasteLabel)
ylim([0,0.6])
ylabel('Fraction of taste-evoked response')
% print('TasteResponse-proportion','-dpdf')
%%
tuning = taste_num(ind_taste);
for i = 1:5
    res(i) = length(find(tuning ==i))
end
figure;
plot(res./size(ind_taste,1),'-o')
xticks([0,1,2,3,4,5,6])
xlim([0,6])
xticklabels({'','1','2','3','4','5',''})
xlabel('Taste Number')
ylabel('Fraction of taste-evoked response')
ylim([0,0.6])
% print('TasteResponse-Tuning','-dpdf')
% legend('2.5 SD')
% xlim([0.5,5.5])
% ylim([0,0.6])
% hold on
%%
figure;
% pie([length(ind),length(ind_cue),length(ind_lick),length(all)-length(ind)-length(ind_lick)-length(ind_cue)])
bar([length(ind_taste),length(ind_cue),length(ind_lick)]./size(taste,1))
set(gca,'xticklabel',{'Taste','Cue','Lick'})
ylabel('Fraction of responsive cells')
ylim([0,0.3])
% print('Response-proportion','-dpdf')
%% plot the overlap between events
cue_taste_lick = intersect(cue_taste,ind_lick);
A = [length(ind_taste),length(ind_cue),length(ind_lick)];
I = [length(cue_taste),length(lick_taste),length(cue_lick),length(cue_taste_lick)];
figure; venn(A,I)
axis image
% print('Response-venn','-dpdf')
%% Plot taste response
taste_resp = neuron_data(ind_taste); % get all the taste response
% taste      = taste(ind,:);
id = {'S','N','CA','Q','W'};
resp = {'S_trace_dF','N_trace_dF','CA_trace_dF','Q_trace_dF','W_trace_dF'};
temp_taste = taste_all(ind_taste,:);
for i = 1:length(id)
    a = find(temp_taste(:,i) == 1); % find response to each of the taste, 1st collumn is S
    for j = 1:length(a)
        resp_amp = full(taste_resp(a(j)).(resp{i}));
        
        temp_time = taste_resp(a(j)).ts_frame.(id{i});
        
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
        clear resp_amp temp_time temp temp_take temp_resp temp_timenorm
    end
end

for i = 1:length(id)
%         figure;
%         imagesc(time.(id{i}),[], tasteid.(id{i}))
%         title(id{i})
%         caxis([-0.1,0.5])
%         xlim([-3.5,3.5])
    % try to sort the neurons
    indd = find(time.(id{i})>0 & time.(id{i})<3.5);
    for j = 1:size(tasteid.(id{i}))
        rank(j) = length(find(tasteid.(id{i})(j,indd)>0.1));
    end
    [B,I]=sort(rank);
    for j=1:size(tasteid.(id{i}),1)
        r=I(j);
        d(j,:)=tasteid.(id{i})(r,:);
    end
    figure
    imagesc(time.(id{i}),[], flipud(d))
    title(id{i})
    caxis([-0.1,0.5])
    xlim([-3.5,3.5])
    colorbar
    %     print(['TasteResponse-',id{i}],'-dpdf')
    clear d rank
end
%% plot average taste response
figure
color = {'c','m','r','k','b'}
for i = 1:length(id)
%     figure;
    r = double(tasteid.(id{i}));
    [h(i),~] = boundedline(time.(id{i}), mean(r),(std(r)./sqrt(size(r,1)))','alpha',color{i});
    hold on
end
legend([h(1),h(2),h(3),h(4),h(5)],id)
xlim([-3.5,3.5])
ylim([-0.1,0.3])
xlabel('Time')
ylabel('dF/F')
% print('TasteResponse-avg','-dpdf')
%% plot cue response
cue_resp = neuron_data(ind_cue);
for i = 1:length(cue_resp)
    for j = 1:size(neuron_data(ind_cue(i)).C_raw_trace,1)
        cue_resp(i).trace(j,:) = neuron_data(ind_cue(i)).C_raw_trace(j,:);
        cue_resp(i).framT(j,:)      =neuron_data(ind_cue(i)).framT(j,:);
    end
    cue(i,:) = mean(full(cue_resp(i).trace));
    time.cue(i,:) = mean(cue_resp(i).framT);
end
time.cue = mean(time.cue);
cue = double(cue);
% figure;
% imagesc(time.cue,[],cue)
% xlim([-1.5,4.5])
% caxis([-0.1,0.5])
figure;
boundedline(time.cue, mean(cue),(std(cue)./sqrt(size(cue,1)))','alpha','b');
xlim([-1.5,4.5])
xlabel('Time')
ylabel('dF/F')
ylim([0,0.3])
% print('ToneResponse','-dpdf')


% try to sort the neurons
indd = find(time.cue>0 & time.cue<2);
for j = 1:size(cue)
    rank(j) = length(find(cue(j,indd)>0.1));
end
[B,I]=sort(rank);
for j=1:size(cue,1)
    r=I(j);
    d(j,:)=cue(r,:);
end
figure
imagesc(time.cue,[], flipud(d))
title('Tone')
xlim([-1.5,4.5])
caxis([0,0.5])
colorbar
% print('ToneResponse-colormap','-dpdf')
clear d rank

 %% plot lick response
% [time.lick , lick] = psth_lick_pop(trial,ind_lick);
% % figure;
% % imagesc(time.lick,[],lick)
% % xlim([-2,4])
% % caxis([-0.2,1.2])
% figure;
% boundedline(time.lick, mean(lick),(std(lick)./sqrt(size(lick,1)))','alpha','b');
% xlim([-2,4])
% xlabel('Time')
% ylabel('dF/F')
% ylim([-0,0.05])
% % print('LickResponse_avg','-dpdf')
% % try to sort the neurons
% indd = find(time.lick>0 & time.lick<1);
% for j = 1:size(lick)
%     rank(j) = length(find(lick(j,indd)>0.02));
% end
% [B,I]=sort(rank);
% for j=1:size(lick,1)
%     r=I(j);
%     d(j,:)=lick(r,:);
% end
% figure
% imagesc(time.lick,[], flipud(d))
% title('Lick')
% xlim([-2,4])
% caxis([0,0.05])
% colorbar
% % print('LickResponse-colormap','-dpdf')

clear d rank
%% re-summarized taste response for clusting
[taste_time, data] = psth_taste_pop_2p(neuron_data,ind_taste);
for i = 1:length(ind_taste)
    idx = find(taste_time.S>0 & taste_time.S <3.5);
    resp_ap(i,1) = max(data.S(i,idx));
    resp_ap(i,2) = max(data.N(i,idx));
    resp_ap(i,3) = max(data.CA(i,idx));
    resp_ap(i,4) = max(data.Q(i,idx));
    resp_ap(i,5) = max(data.W(i,idx));
end

resp_ap = resp_ap.*temp_taste; % taste response for each neuron.
%% hierarchical cluster
% % Y = pdist(resp_ap,'correlation');
% Y = pdist(resp_ap./max(resp_ap,[],2),'euclidean');
% Z = linkage(Y,'average');
% % T = cluster(Z,'maxclust',8)
% figure;
% % lin_rh = dendrogram(Z,0,'orientation','right')
% lin_rh = dendrogram(Z,0)
% 
% cutoff = median([Z(end-8,3) Z(end-8,3)]);
% dendrogram(Z,0,'ColorThreshold',cutoff)
resp_ap(find(mean(resp_ap,2)<=0),:)=[];
[T, outperm] = hierarchical_cluster(resp_ap)
% Clusters = hierarcluster(resp_ap);
% print('Cluster_dendrogram','-dpdf')
%% plot the normalized responses
% for i = 1:length(Clusters)
%     norResp(i).ap = resp_ap(Clusters{i},:);
%     norResp(i).ap = norResp(i).ap./max(norResp(i).ap,[],2);
%     a = norResp(i).ap;
%     mean_a = mean(a);
%     sem_a  = std(a)./sqrt(size(a,1));
%     figure;
%     bar(mean_a)
%     hold on
%     errorbar(mean_a,sem_a)
%     title(['Cluster ',num2str(i)])
%     ylim([0,1])
% %     print(['Cluster_C',num2str(i)],'-dpdf')
% end
%% Let's calculate the entropy H = -k *sum (p * log10(p))
% k = 1/log10(5);
% for i = 1:length(Clusters)
%     nn = norResp(i).ap;
%     nn = nn./sum(nn,2);
%     for j = 1:size(nn,1)
%         nnn = nn(j,:);
%         p_logp = nnn.*log10(nnn);
%         p_logp(isnan(p_logp)) = 0;
%         entrop(i).h(j) = -k*sum(p_logp);       
%     end
%     
% end
% figure
% for i =1:length(Clusters)
%     m(i) = mean(entrop(i).h)
%     sem(i) = std(entrop(i).h)/sqrt(length(entrop(i).h));
%     bar(i,m(i))
%     hold on
% end
% ylim([0,1])
% errorbar(m,sem)
% name = {[],'1','2','3','4','5','6','7','8','9',[]}
% set(gca,'XTick',0:10)
% set(gca,'xticklabel',name)
% xlabel('Cluster')
% ylabel('Entropy')
% print('Cluster_entropy','-dpdf')
%% similarity between taste
% Y = pdist(resp_ap','cosine');
% Z = squareform(Y);
% figure;
% imagesc(Z)
%% spatial information
% let's use the best taste method;
%% session 1: 1-28; session 2: 29-32; session 3:33-44
[M, I] = max(resp_ap,[],2);
for i = 1:length(id)
    best.(id{i}) = find(I ==i );
    best.summary(i) = length(find(I ==i ));
end
figure;
bar(best.summary/size(resp_ap,1))
tasteLabel = {'S','N','CA','Q','W'};
set(gca,'xticklabel',tasteLabel)
ylim([0,0.3])
ylabel('Fraction of best taste')
% print('Best taste','-dpdf')
%% spatial map
% spatialMap_1p(neuron,Coor,ind_cue,ind_lick,ind_taste)
spatialMap_1p_v2(neuron,Coor,neuron_data)
spatialMap_1p_v3(neuron,Coor,neuron_data, best, ind_taste)
%%
% for i = 1:length(id)
%     amp(1,i) = mean(M(best.(id{i})));
%     amp(2,i) = std(M(best.(id{i})))./sqrt(size(M(best.(id{i})),1));   
% end
% figure;
% bar(amp(1,:))
% hold on
% errorbar(amp(1,:),amp(2,:))
for i = 1:length(id)
    amp2(1,i) = mean(resp_ap(find(resp_ap(:,i)~=0),i));
    amp2(2,i) = std(resp_ap(find(resp_ap(:,i)~=0),i))./sqrt(size(resp_ap(find(resp_ap(:,i)~=0),i),1));   
end
% 
figure;
bar(amp2(1,:))
hold on
errorbar(amp2(1,:),amp2(2,:))
% ylim([0,0.4])
ylabel('Evoked response(dF/F)')
tasteLabel = {'S','N','CA','Q','W'};
set(gca,'xticklabel',tasteLabel)
y =[];
label =[];
for i = 1:5
    idx_temp = find(resp_ap(:,i)>0);
    temp_t = resp_ap(idx_temp,i);
    y = [y;temp_t];
    label = [label;i*ones(size(temp_t))];
end
[p,tbl]= anova1(y,label)
% print('Evoke_response','-dpdf')
% %% 
% clear taste_sp
% % file = {'RVKC368\180807','RVKC368\180809','RVKC368\180814','RVKC377\180828','RVKC402\181029','RVKC403\181029'...
% %     ,'RVKC403\181030','RVKC403\181031','RVKC404\181119','RVKC405\181119','RVKC405\181120'};
% % file = {'RVKC368\180731','RVKC377\180821','RVKC402\181022','RVKC403\181022'...
% %     ,'RVKC404\181112','RVKC405\181112'};
% 
% % Load each Imaging data from Session 2
% % file = {'RVKC368\180802','RVKC377\180823','RVKC402\181024','RVKC403\181024'...
% %     ,'RVKC404\181114','RVKC405\181114'};
% 
% % Load each Imaging data from Session 3
% file = {'RVKC368\180807','RVKC377\180828','RVKC402\181029','RVKC403\181029'...
%     ,'RVKC404\181119','RVKC405\181119'};
% for i = 1:length(file)
%     date = file{i}(end-5:end); % separate different sessions
%     animalID = file{i}(1:7);
%      iii = find(strcmp({taste_resp.date},date));
%      ii  = find(strcmp({taste_resp.animalID},animalID));
%      taste_sp(i).ss = intersect(ii,iii);
% end
% 
% for i = 1:length(file) % get the neurons for each best stimulus for each session
%     for j = 1:length(id)
%         taste_sp(i).(id{j}) = best.(id{j})(find(best.(id{j}) >= taste_sp(i).ss(1) & best.(id{j})<=taste_sp(i).ss(end)));
%     end
% end
% marker = {'S_loc','N_loc','CA_loc','Q_loc','W_loc'};
% dd     = {'S_d','N_d', 'CA_d','Q_d','W_d'};
% 
% for i = 1:length(file) % calculate the spatial distance
%     for j = 1:length(id)
%         if isempty(taste_sp(i).(id{j}))
%             taste_sp(i).(marker{j}) = [];
%         elseif length(taste_sp(i).(id{j})) ==1
%             taste_sp(i).(marker{j}) =taste_resp(taste_sp(i).(id{j})).cc; % spatial location;
%             taste_sp(i).(dd{j})     = [];
%         else
%             for k = 1:length(taste_sp(i).(id{j}))
%                 taste_sp(i).(marker{j})(k,:) =taste_resp(taste_sp(i).(id{j})(k)).cc;
%             end
%                 taste_sp(i).(dd{j})     = pdist(taste_sp(i).(marker{j})); % spatical distance;
%         end
%     end
% end
% clear m sem
% figure;
% for i = 1:length(dd)
%     m(i) = mean([taste_sp.(dd{i})]);
%     sem(i) = std([taste_sp.(dd{i})])/sqrt(length([taste_sp.(dd{i})]));
%     bar(i,m(i))
%     hold on
% end
% errorbar(m,sem)
% 
% % stats for the location
% kwtest = [];
% clear a ;
% for i = 1:length(dd)
%     a(:,1) = [taste_sp.(dd{i})];
%     a(:,2) = i;
%     kwtest = [kwtest; a];
%     clear a
% end
% [p,tbl,stats] = kruskalwallis(kwtest(:,1),kwtest(:,2));
% c = multcompare(stats);
% %% pairwise distance between tastant
% for i = 1:length(taste_sp)
%     for j = 1:length(taste_sp(i).ss)
%         taste_sp(i).sumloc(j,:)  = [taste_resp(taste_sp(i).ss(j)).cc];
%     end
%     taste_sp(i).sumdis      = pdist(taste_sp(i).sumloc);
% end
% nst   = setdiff([taste_sp.sumdis],kwtest(:,1));
% com   = intersect([taste_sp.sumdis],kwtest(:,1));
% m(6) = mean(nst);
% sem(6) = std(nst)./sqrt(length(nst));
% figure;
% bar(m)
% hold on
% errorbar(m,sem)
% nt(:,1) = (datasample(nst,100,'Replace',false))';
% nt(:,2) = 6;
% kwtest = [kwtest; nt];
% [p,tbl,stats] = kruskalwallis(kwtest(:,1),kwtest(:,2));
% figure
% c = multcompare(stats);
% 
% 
% %% Plot the spatial map
% spatialMap_1p(neuron,Coor,ind_cue,ind_lick,ind_taste)
% %%
% for i = 1:length(file)
%     animalID = file{i}(1:7);
%     date     = file{i}(9:end);
%     spatialMap_v2(all,animalID,date,ind_taste_true)
% end
% %% plot spatial distribution between cue and taste
% for i = 1:length(file)
%     animalID = file{i}(1:7);
%     date     = file{i}(9:end);
%     [distance(i)]= spatialMap_v3(all,animalID,date,ind_cue,ind_lick_true,ind_taste_true);
% end
% 
% 
% cue = [distance.cue];
% cuePse = [distance.cuePse];
% [h1,p1] = ttest2(cue,cuePse);
% lick=  [distance.lick];
% taste = [distance.taste];
% tastePse = [distance.tastePse];
% [h3,p3]= ttest2(taste,tastePse);
% 
% figure;
% h1 = histogram(cue);
% hold on
% h2 = histogram(cuePse);
% % h3 = histogram(taste);
% h1.Normalization = 'probability';
% h1.BinWidth = 20;
% h2.Normalization = 'probability';
% h2.BinWidth = 20;
% xlabel('Distancee (um)')
% ylabel('Probability')
% legend()
% print('Spatial-Distance-cue','-dpdf')
% 
% 
% figure;
% h1 = histogram(taste);
% hold on
% h2 = histogram(tastePse);
% % h3 = histogram(taste);
% h1.Normalization = 'probability';
% h1.BinWidth = 20;
% h2.Normalization = 'probability';
% h2.BinWidth = 20;
% xlabel('Distancee (um)')
% ylabel('Probability')
% legend()
% print('Spatial-Distance-taste','-dpdf')
% save('distance.mat','distance')
% %% plot spatial distribution between different taste
% for i = 1:length(file)
%     animalID = file{i}(1:7);
%     date     = file{i}(9:end);
%     distanceTaste(i) = spatialMap_v4(all,animalID,date,ind_taste_true);
% end
% 
% f = fieldnames(distanceTaste);
% for i = 1:length(f)
%     sumDistTaste.(f{i})= [distanceTaste.(f{i})];
%     figure
%     h = histogram([distanceTaste.(f{i})]);
%     h.Normalization = 'probability';
%     h.BinWidth = 20;
%     value = h.Values;
%     for j = 1:length(value);
%         time(j) = mean(h.BinEdges(j:j+1));
%     end
%     forplot.(f{i}) = [time;value];
%     clear time
%     close all
% end
% figure
% for i = 1:length(f)
%     plot(forplot.(f{i})(1,:),forplot.(f{i})(2,:))
%     hold on
% end
% legend(f)
% xlabel('Distance (um)')
% ylabel('probability')
% print('Spatial-Distance-5taste','-dpdf')
% save('distance.mat','distance','distanceTaste')
% % h3.Normalization = 'probability';
% % h3.BinWidth = 20;
% % [h,p] = ttest2(cue, taste,'Vartype','unequal')
% % taste2 = datasample(taste,length(cue),'Replace',false);