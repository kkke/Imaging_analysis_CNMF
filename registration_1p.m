% demo file for applying the NoRMCorre motion correction algorithm on
% 1-photon widefield imaging data
% Example file is provided from the miniscope project page
% www.miniscope.org
function registration_1p(filename)
% this code uses server to perform registration for 1p data
addpath(genpath('/MATLAB/NoRMCorre'));
% clear;
gcp;
%% download data and convert to single precision
% name = 'RVKC438_2019-08-17_avg2.avi';
name = filename;
tic
fprintf('Loading data...\n')
Yr = read_file(name);
fprintf('Finish loading data, cost %f s\n',toc)
[d1,d2,T] = size(Yr);
tic
% Y_ds = downsample_data(Yr,'space',2); % downsampled the data
Yr = single(Yr);
% fprintf('Finish downsampling data in %f\n', toc)

%addpath(genpath('../../NoRMCorre'));
%% perform some sort of deblurring/high pass filtering
% The function does not load the whole file in memory. Instead it loads
% chunks of the file and then saves the high pass filtered version in a
% h5 file.

gSig = 4;
gSiz = 3*gSig;
psf = fspecial('gaussian', round(2*gSiz), gSig);
ind_nonzero = (psf(:)>=max(psf(:,1)));
psf = psf-mean(psf(ind_nonzero));
psf(~ind_nonzero) = 0;   % only use pixels within the center disk

[filepath,file_name,ext] = fileparts(name);
h5_name = fullfile(filepath,[file_name,'_filtered_data.h5']);
h5_name_down = fullfile(filepath,[file_name,'_downsampled.h5']);
fprintf('Filtering the data\n')
tic
Y = imfilter(Yr,psf,'symmetric');
fprintf('Finish the filtering in %f...\n', toc)
% fprintf('Saving the data...\n')
tic
%% save file in small chunks
% chunksize = 1500;
% cnt = 1
% for i = 1: ceil(size(Y,3)/chunksize)
%     if cnt-1 + chunksize<size(Y,3)
%         tic
%         saveash5(Y(:,:,cnt:(cnt-1)+chunksize),h5_name);
% %         saveash5(Y_ds(:,:,cnt:(cnt-1)+chunksize),h5_name_down);
%         cnt = cnt+chunksize;
%         fprintf('Finish saving the %2.1f %5.2f', i,toc)
%         
%     else
%         tic
%         saveash5(Y(:,:,cnt:end),h5_name);
% %         saveash5(Y_ds(:,:,cnt:end),h5_name_down);
%         fprintf('Finish saving the %2.1f %5.2f', i,toc)
%     end
% end
%% first try out rigid motion correction
% exclude boundaries due to high pass filtering effects
options_r = NoRMCorreSetParms('d1',d1,'d2',d2,'bin_width',200,'max_shift',20,'iter',1,'correct_bidir',false);
% options_r.output_type = 'h5';
% options_r.h5_filename =[file_name,'_registered.h5'];
%% register using the high pass filtered data and apply shifts to original data
% tic; [M1,shifts1,template1] = normcorre_batch(h5_name,options_r); toc % register filtered data
tic; [M1,shifts1,template1] = normcorre_batch(Y,options_r); toc % register filtered data
% exclude boundaries due to high pass filtering effects
save('registration_setting.mat','shifts1','options_r')
% if you save the file directly in memory make sure you save it with a
% name that does not exist. Change options_r.tiff_filename
% or options_r.h5_filename accordingly.

tic; Mr = apply_shifts(name,shifts1,options_r); toc % apply shifts to full dataset
savefile = [name(1:end-4),'_reg.h5'];
saveash5(Mr,savefile)
% you can only save the motion corrected file directly in memory by
% setting options_r.output_type = 'tiff' or 'h5' and selecting an
% appropriate name through options_r.tiff_filename or options_r.h5_filename