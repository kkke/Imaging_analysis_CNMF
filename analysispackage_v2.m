function datasave = analysispackage_v2(all, all_align) % also include inhibitory response
f = fieldnames(all);
taste = rmfield(all,f(6:end));
taste = cell2mat(squeeze(struct2cell(taste)))';
taste_all =taste;
taste_all(find(taste_all ==-1))=1; % include inhibitory response
all_num = sum(taste_all,2); % get the evoked response
evoke_ratio = length(find(all_num>0))/length(all_num);
taste_num = sum(taste_all(:,1:5),2);
ind_taste      = find(taste_num>0);
ind_cue  = find([all.CueRes]~=0);
ind_lick = find([all.LickRes]~=0);
% ind_lick_neg = find([all.LickRes]==-1);
lick_taste= intersect(ind_taste,ind_lick); % starts to clarify the lick response and taste response
lick_taste_res = cell2mat(squeeze(struct2cell(rmfield(all_align,f(6:end)))))';% take the matrix where stats baseline is 1 s before taste
lick_taste_res(find(lick_taste_res ==-1))=1; % only analyze the excitatory response
lick_taste_res_sum = sum(lick_taste_res,2); % 
lick_taste_res_sum = lick_taste_res_sum(lick_taste);% find the responsive one
lick_taste_Notaste = lick_taste(find(lick_taste_res_sum==0));
%%%%%%%%%%%%%%True taste Response%%%%%%%%%%%%%%%%%
ind_taste_true = setdiff(ind_taste,lick_taste_Notaste);
all_temp = all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cue_lick  = intersect(ind_cue,ind_lick); % start to clarify the cue response and lick response
cue_lick_res = ([all_align.LickRes]); % this response is based on 1 s before lick as baseline
cue_lick_res(find(cue_lick_res==-1))=1;
cue_lick_res = cue_lick_res(cue_lick);
cue_lick_Nolick = cue_lick(find(cue_lick_res==0));
%%%%%%%%%%%Get the True lick response %%%%%%%%%
ind_lick_true = setdiff(ind_lick,cue_lick_Nolick);
%% do some plotting
%%%See overlap%%%%%
% Let's go back the all_temp
all = all_temp;
clearvars -except ind_cue ind_lick_true ind_taste_true all
cue_lick  = intersect(ind_cue,ind_lick_true);
cue_taste = intersect(ind_taste_true,ind_cue);
lick_taste= intersect(ind_taste_true,ind_lick_true);

f = fieldnames(all);
taste = rmfield(all(ind_taste_true),f(6:end));
taste = cell2mat(squeeze(struct2cell(taste)))';
taste(find(taste==-1))=0;
tuning = sum(taste,2);

figure;
bar(sum(taste)./size(taste,1))
tasteLabel = {'S','N','CA','Q','W'};
set(gca,'xticklabel',tasteLabel)
ylim([0,0.6])
ylabel('Fraction of taste-evoked response')
% print('TasteResponse-proportion','-dpdf')
%%
for i = 1:5
    res(i) = length(find(tuning ==i))
end
figure;
plot(res./size(taste,1),'-o')
xticks([0,1,2,3,4,5,6])
xlim([0,6])
xticklabels({'','1','2','3','4','5',''})
xlabel('Taste Number')
ylabel('Fraction of taste-evoked response')
ylim([0,0.5])
datasave.tuning.res = res;
datasave.tuning.all = size(taste,1);
% print('TasteResponse-Tuning','-dpdf')
% legend('2.5 SD')
% xlim([0.5,5.5])
% ylim([0,0.6])
% hold on
%%
figure;
% pie([length(ind),length(ind_cue),length(ind_lick),length(all)-length(ind)-length(ind_lick)-length(ind_cue)])
bar([length(ind_taste_true),length(ind_cue),length(ind_lick_true)]./length(all))
set(gca,'xticklabel',{'Taste','Cue','Lick'})
ylabel('Fraction of responsive cells')
ylim([0,0.3])
datasave.tasteRespCount = length(ind_taste_true);
datasave.cueRespCount   = length(ind_cue);
datasave.lickRespCount  = length(ind_lick_true);
datasave.allCellCount   = length(all);
% print('Response-proportion','-dpdf')
%% plot the overlap between events
cue_taste_lick = intersect(cue_taste,ind_lick_true);
A = [length(ind_taste_true),length(ind_cue),length(ind_lick_true)];
I = [length(cue_taste),length(lick_taste),length(cue_lick),length(cue_taste_lick)];
figure; venn(A,I)
axis image
datasave.overlap.A =A;
datasave.overlap.I =I;
% print('Response-venn','-dpdf')
%% Plot taste response
taste_resp = all(ind_taste_true); % get all the taste response
% taste      = taste(ind,:);
id = {'S','N','CA','Q','W'}
resp = {'S_Taste_dF','M_Taste_dF','CA_Taste_dF','Q_Taste_dF','W_Taste_dF'};
for i = 1:length(id)
    a = find(taste(:,i) == 1); % find response to each of the taste, 1st collumn is S
    for j = 1:length(a)
        t = taste_resp(a(j)).(resp{i});
        time.(id{i})(j,:) = taste_resp(a(j)).T;
        tasteid.(id{i})(j,:) = mean(t,1);
    end
end

for i = 1:length(id)
    time.(id{i}) = mean(time.(id{i}))
end
for i = 1:length(id)
%     figure;
%     imagesc(time.(id{i}),[], tasteid.(id{i}))
%     title(id{i})
%     caxis([-0.1,0.5])
%     xlim([-3.5,3.5])
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
datasave.TasteResponse.time = time;
datasave.TasteResponse.ap   = tasteid;
legend([h(1),h(2),h(3),h(4),h(5)],id)
xlim([-3.5,3.5])
ylim([-0.1,0.3])
xlabel('Time')
ylabel('dF/F')
% print('TasteResponse-avg','-dpdf')
%% plot cue response
cue_resp = all(ind_cue);
for i = 1:length(cue_resp)
    cue(i,:) = mean(cue_resp(i).trace_dF);
    time.cue(i,:) = cue_resp(i).framT;
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
ylim([-0.1,0.3])
datasave.CueResponse.time = time;
datasave.CueResponse.ap   = cue;
%% plot lick response
lick_resp = all(ind_lick_true);
% lick_resp = all(ind_lick_neg);
for i = 1:length(lick_resp)
    lick(i,:) = mean(lick_resp(i).Licktrace_dF);
    time.lick(i,:) = lick_resp(i).TLick;
end
datasave.LickResp.time = mean(time.lick);
datasave.LickResp.ap = double(lick);
figure;
boundedline(mean(time.lick), mean(lick),(std(lick)./sqrt(size(lick,1)))','alpha','b');
xlim([-2,4])
xlabel('Time')
ylabel('dF/F')
ylim([-0.1,0.3])