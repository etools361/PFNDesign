%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2024-2-25(yyyy-mm-dd)
% Split some items
%--------------------------------------------------------------------------
function [sout] = funSplitPartfrac(s)
s1 = string(s);
s2 = regexp(s1, ' \+ ', 'split');
s3 = funSplitPartfracPM(s2, '+');
ms3 = length(s3);
s6  = [];
for ii=1:ms3
    s4 = regexp(s3{ii}, ' - ', 'split');
    if length(s4)>1
        s5 = funSplitPartfracPM(s4, '-');
        s6 = [s6, s5];
    else
        s6 = [s6, s3(ii)];
    end
end

sout = s6;

function s3 = funSplitPartfracPM(s2, strPM)
ns3 = 1;
ishist = [];
ns2 = length(s2);
for ii=1:ns2
    cs2 = s2{ii};
    if ~isempty(ishist)
        ishist = [ishist, ' ', strPM, ' ', cs2];
    else
        ishist = cs2;
    end
    [l1, la] = regexp(ishist, '\(', 'match');
    [r1, ra] = regexp(ishist, '\)', 'match');
    if length(l1)==0 && length(r1)==0 && isempty(ishist)
        if ns3>1 && strPM == '-'
            ishist = ['- ', ishist];
        end
        s3{ns3} = ishist;ns3=ns3+1;
        ishist  = [];
    elseif length(l1)==length(r1) && ~sum(ra-la<=0)
        if ns3>1 && strPM == '-'
            ishist = ['- ', ishist];
        end
        s3{ns3} = ishist;ns3=ns3+1;
        ishist  = [];
    end
end

