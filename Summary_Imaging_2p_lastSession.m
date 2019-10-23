
clear
close all
file = 'RVKC368';
date = {'180807','180809','180814'};
for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end

%%
clear; close all
file = 'RVKC377';
date = {'180828'};
for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%%
clear; close all
file = 'RVKC402';
date = {'181029'};

for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%%
close all;clear
file = 'RVKC403';
date = {'181029','181030','181031'};

for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%%
close all;clear
file = 'RVKC404';
date = {'181119'};

for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%%
clear;close all
file = 'RVKC405';
date = {'181119','181120'};

for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%%
%%
clear;close all
file = 'RVKC418';
date = {'190401','190402'};

for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%%
clear
file = 'RVKC428';
% date = {'190624','190626'};
date = {'190701','190702'};

for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%%
file = 'RVKC429';
% date = {'190624','190626'};
date = {'190701','190702'};

for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%%
file = 'RVKC425';
date = {'190708'};
% for i = 1:length(date)
%     imaging_analysis_GC_v6(file,date{i})
% end
for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%%
file = 'RVKC426';
date = {'190708'};
% for i = 1:length(date)
%     imaging_analysis_GC_v6(file,date{i})
% end
for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%
file = 'RVKC438';
date = {'190814'};

for i = 1:length(date)
    animalID = file;
    imaging_analysis_GC_2p(animalID,date{i})
    close all
end
%%
clear
close all
disk = 'F:'
file = 'RVKC368';
date = {'180807','180809','180814'};
k = 1;
for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end

file = 'RVKC377';
date = {'180828'};
for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end
%

file = 'RVKC402';
date = {'181029'};
for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end

%

file = 'RVKC403';
date = {'181029','181030','181031'};

for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end
%

file = 'RVKC404';
date = {'181119'};
for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end
%

file = 'RVKC405';
date = {'181119','181120'};
for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end

file = 'RVKC418';
date = {'190401','190402'};
for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end

disk = 'G:';
file = 'RVKC428';
% date = {'190624','190626'};
date = {'190701','190702'};

for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end
%
file = 'RVKC429';
% date = {'190624','190626'};
date = {'190701','190702'};
for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end
%
file = 'RVKC425';
date = {'190708'};
for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end
%
file = 'RVKC426';
date = {'190708'};
for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end
%
file = 'RVKC438';
date = {'190814'};
for i = 1:length(date)
    data(k).disk = disk;
    data(k).animalID = file;
    data(k).date     = date{i};
    k = k+1;
end

save('lastImagingSession.mat','data')
