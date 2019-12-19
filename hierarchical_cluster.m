function [T, outperm] = hierarchical_cluster(resp_ap)
resp_ap_scaled = resp_ap./max(resp_ap,[],2);
Z = linkage(resp_ap_scaled,'ward','euclidean');
T = cluster(Z,'maxclust',9);
cutoff = median([Z(end-8,3) Z(end-7,3)]);
figure
[H,tt,outperm] = dendrogram(Z,0,'ColorThreshold',cutoff);
figure;
for i = 1:5
subplot(5,1,i)
bar(resp_ap_scaled(outperm,i))
hold on
end
%% plot the normalized responses
for i = 1:9
    norResp(i).ap = resp_ap(find(T==i),:);
    norResp(i).ap = norResp(i).ap./max(norResp(i).ap,[],2);
    a = norResp(i).ap;
    mean_a = mean(a);
    sem_a  = std(a)./sqrt(size(a,1));
    figure;
    bar(mean_a)
    hold on
    errorbar(mean_a,sem_a)
    title(['Cluster ',num2str(i)])
    ylim([0,1])
%     print(['Cluster_C',num2str(i)],'-dpdf')
end
k = 1/log10(5);
for i = 1:9
    nn = norResp(i).ap;
    nn = nn./sum(nn,2);
    for j = 1:size(nn,1)
        nnn = nn(j,:);
        p_logp = nnn.*log10(nnn);
        p_logp(isnan(p_logp)) = 0;
        entrop(i).h(j) = -k*sum(p_logp);       
    end
    
end
figure
for i =1:9
    m(i) = mean(entrop(i).h)
    sem(i) = std(entrop(i).h)/sqrt(length(entrop(i).h));
    bar(i,m(i))
    hold on
end
ylim([0,1])
errorbar(m,sem)
name = {[],'1','2','3','4','5','6','7','8','9',[]}
set(gca,'XTick',0:10)
set(gca,'xticklabel',name)
xlabel('Cluster')
ylabel('Entropy')
