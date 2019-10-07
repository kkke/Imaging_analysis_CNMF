%% data analysis code for 1p data
% load imaging data
file = '03-Oct_21_21_21.mat';
load(file)
% remove fake neurons
[fakeneuron,neuron_new] = detectfake(neuron);

% view neurons
% i = 1;
% neuron_new.save_neurons(); 
% neuron_new.viewNeurons([]); 
neuron.viewNeurons(1,neuron.C_raw);
Coor = neuron.show_contours(0.8);
figure; 
[CC,jsf] = plot_contours(neuron.A,neuron.Cn,);
noise = [1334 1343 1329 1357 1345 1351 1336 1355 1350 1356, 594];

A = neuron.reshape(neuron.A, 2);
imagesc(A(:,:,1))

%% load Intan data
filename = 'RVKC441_191001.rhd';
data = read_Intan(filename);
[Frame,~] = Timing_onset_offset(data.event(7,:), data.ts, 0.5,10,0);
[Tone,~]  = Timing_onset_offset(data.event(6,:), data.ts, 0.5,100,0);
[W,~]     = Timing_onset_offset(data.event(5,:), data.ts, 0.5,10,0);
[Q,~]     = Timing_onset_offset(data.event(4,:), data.ts, 0.5,10,0);
[CA,~]    = Timing_onset_offset(data.event(3,:), data.ts, 0.5,10,0);
[N,~]     = Timing_onset_offset(data.event(2,:), data.ts, 0.5,10,0);
[S,~]     = Timing_onset_offset(data.event(1,:), data.ts, 0.5,10,0);
[licks,~] = Timing_onset_offset(-data.analog(1,:), data.ts, -0.2,100,1);

% 

for i = 1: floor(length(Frame)/2)
    ts_frame(i) = mean(Frame(2*i-1:2*i));
end

% visualize the calcium traces
figure;
plot(ts_frame,neuron.C_raw(1,:))
hold on
scatter(S,ones(size(S)),'ro','filled')
scatter(N,ones(size(N)),'bo','filled')
scatter(CA,ones(size(CA)),'yo','filled')
scatter(Q,ones(size(Q)),'co','filled')
scatter(W,ones(size(W)),'ko','filled')




