clear;close all
load('data_CNMF')
[CC,jsf,im] = plot_contours(A_keep,Cn,options,1);

gui2p_Calman3(CC,Cn,jsf,F_dff);
%% for representative examples for spatial map
% figure;
% plot(F_dff(104,:))
% plot_components_GUI(data,A_keep,C_keep,b,f,Cn,options);
load('reject.mat')
reject = unique(reject);
figure;imagesc(Cn)
CC(reject)=[];
S_dec(reject,:) = [];
hold on
for i = 1:length(CC)
        plot(CC{i}(1,:), CC{i}(2,:), 'r', 'LineWidth', 1)
        % red means cue response
        hold on 
end
axis image
axis off
title('RVKC402-181029')
print('ROImap-RVKC402-181029','-dpdf')
%%
figure;
for i = 65:76
    plot(S_dec(i,:)+i)
    hold on
    
end