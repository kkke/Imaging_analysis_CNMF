function [t_on t_off]=Timing_onset_offset(data, timestamps, threshold,spacing,fig)
%% this scripts is for quick extract the timestamps of the onset and offset of any analog signal
% INPUT:
%
%        data
%        timestamps
%        threshold: for analog to cross, very import; the spacing is set as
%        30 in default.
%        fig: 1 is to plot figure; 
% data and timestamps are the analog signal loaded with load_open_ephys_data function
% [data, timestamps, info] = load_open_ephys_data('100_C-Lick.continuous');
% OUTPUT:
%        t_on is the timestamps of the onset of analog signal passing the
%        threshold
%        t_off is the timestamps of the offset of analog signal passing the
%        threshlod
% The default threshold =3, if not specified.
if nargin <3
    threshold=3;
    fig = 0;
    spacing = 30;
end

loc=find(data>threshold);
if isempty(loc)
    t_on  = [];
    t_off = [];
else
    l=diff(loc);
    clear onset
    onset(1)=loc(1);
    if isempty(find(l>1))% add by ke to avoid there is only one event
        offset(1)=loc(end);
    else
        a=find(l>spacing);
        a=a+1;
        for i=1:length(a)
            onset(i+1)=loc(a(i));
        end
        b=find(l>30);
        % clear offset
        for i=1:length(b)
            offset(i)=loc(b(i));
        end
        offset(end+1)=loc(end);
    end
    if fig ==1
        figure
        plot(timestamps,data)
        hold on
        plot(timestamps(onset), ones(size(onset)),'*')
        plot(timestamps(offset),3*ones(size(offset)),'*')
        hold off
    else
    end
    %
    % clear t_onset t_offset
    t_on=timestamps(onset);
    t_off=timestamps(offset);
end
