file = 'RVKC368';
% date = {'180807','180809','180814'};
% date = {'180731', '180802'};
date = {'180731', '180802','180807','180809','180814'};

for i = 1:length(date)
    foldername = ['F:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%%
file = 'RVKC377';
% date = {'180828'};
% date = {'180821', '180823'};
date = {'180821', '180823','180828'};


for i = 1:length(date)
    foldername = ['F:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%%
file = 'RVKC402';
% date = {'181029'};
date = {'181022', '181024','181029'};

for i = 1:length(date)
    foldername = ['F:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%%
file = 'RVKC403';
% date = {'181029','181030','181031'};
date = {'181022', '181024','181029','181030','181031'};

for i = 1:length(date)
    foldername = ['F:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%%
file = 'RVKC404';
% date = {'181119'};
date = {'181112', '181114','181119'};
for i = 1:length(date)
    foldername = ['F:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%%
file = 'RVKC405';
% date = {'181119','181120'};
% date = {'181119'};
date = {'181112', '181114','181119','181120'};
for i = 1:length(date)
    foldername = ['F:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%%
file = 'RVKC417';
date = {'190325','190327'};
for i = 1:length(date)
    foldername = ['F:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end

%%
file = 'RVKC418';
date = {'190401','190402'};
for i = 1:length(date)
    foldername = ['F:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%%
file = 'RVKC428';
% date = {'190624','190626'};
date = {'190701','190702'};
for i = 1:length(date)
    foldername = ['G:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%%
file = 'RVKC429';
% date = {'190624','190626'};
date = {'190701','190702'};
for i = 1:length(date)
    foldername = ['G:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%%
file = 'RVKC425';
% date = {'190624','190626'};
date = {'190701','190703','190708'};
for i = 1:length(date)
    foldername = ['G:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%%
file = 'RVKC426';
date = {'190701','190703','190708'};
for i = 1:length(date)
    foldername = ['G:\Imaging in GC\ImagingData\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end
%% 
file = 'RVKC438';
date = {'190807','190809','190814'};
for i = 1:length(date)
    foldername = ['D:\Imagingdata\',file,'\',date{i},'\1']
    cd(foldername)
    run_pipeline_Ke(foldername)
end