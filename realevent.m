function event = realevent(duration)
ili = duration;
ili(isnan(ili))=[]; % remove NaN
% ili(1) =[];         % remove the first collumn which is the trial sequence.
b=find(ili>3);     % inter lick interval is bigger than 500 ms, which means a new licking bouts
if ~isempty(b)
    for i=1:length(b)
        if i==1;
            bouts{1}=1:b(1)-1;
            ici(i) = ili(b(1));
        else
            bouts{i}=b(i-1)+1:b(i)-1;
            ici(i) = ili(b(i));
        end
    end
    bouts{i+1}=b(i)+1:length(ili); % all the bouts including less than 3 licks
else
    bouts{1} = 1:length(ili);
    ici = nan;
end
for i = 1:length(bouts)
    allduration(i) = sum(ili(bouts{i}));
    alllickCount(i) = length(bouts{i})+1;
end
lickSpont=[];
% find out the event which laste at least 5 frames
for i=1:length(bouts)
    if length(bouts{i})<5
       randlick=bouts{i};
       bouts{i}=[];
       lickSpont=[lickSpont randlick];
    end  
end
bouts=bouts(~cellfun('isempty',bouts)); % all the real bouts 

% lickSpont=ili(lickSpont); % timestamps of all Non-bouts licks
for i = 1:length(bouts)
    duration(i) = sum(ili(bouts{i}));
    lickCount(i) = length(bouts{i})+1;
end
if ~isempty(bouts)
    
    licking.ili=ili;
    licking.allduration=allduration;
    licking.alllickCount=alllickCount;
    licking.duration = duration;
    licking.lickCount = lickCount;
    licking.ici          = ici;
else
    licking.ili=ili;
    licking.allduration=[];
    licking.alllickCount=[];
    licking.duration = [];
    licking.lickCount = [];
    licking.ici          = [];  
end
event = licking;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
