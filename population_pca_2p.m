% the input is the data; from the summary_2p
f = fieldnames(data);
for i = 1:size(data.S,1)
    for j = 1:length(f)
        temp(j,:) = data.(f{j})(i,:);
    end
    pop_avg(i,:) = mean(temp);
    clear temp
end

[coeff,score,latent,tsquared,explained,mu] = pca(pop_avg(:,23:end)');
S_traj = (data.S(:,23:end)'-mu)*coeff(:,1:3);
N_traj = (data.N(:,23:end)'-mu)*coeff(:,1:3);
CA_traj = (data.CA(:,23:end)'-mu)*coeff(:,1:3);
Q_traj= (data.Q(:,23:end)'-mu)*coeff(:,1:3);
W_traj= (data.W(:,23:end)'-mu)*coeff(:,1:3);
figure;
plot3(S_traj(:,1),S_traj(:,2),S_traj(:,3))
hold on
plot3(N_traj(:,1),N_traj(:,2),N_traj(:,3))
plot3(CA_traj(:,1),CA_traj(:,2),CA_traj(:,3))
plot3(Q_traj(:,1),Q_traj(:,2),Q_traj(:,3))

figure;
plot(S_traj(:,1),S_traj(:,2))
hold on
plot(N_traj(:,1),N_traj(:,2))
plot(CA_traj(:,1),CA_traj(:,2))
plot(Q_traj(:,1),Q_traj(:,2))