%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2024-2-25(yyyy-mm-dd)
% Remove some items
%--------------------------------------------------------------------------
function [sout] = funRmPartfrac(s, tol)
[sn] = funSplitPartfrac(s);
m_sn = length(sn);
sn_comb = [];
isnew = 1;
for ii=1:m_sn
    s4 = str2sym(sn{ii});
    [n,d]=numden(s4);
    cn = vpa(coeffs(n, 'all'));
    cd = vpa(coeffs(d, 'all'));
    cn = cn/cd(1);
    cd = cd/cd(1);
    cn(cn<tol) = 0;
    if sum(cn)<tol
    else
        if isnew
            sn_comb = sn{ii};
            isnew = 0;
        else
            if sn{ii}(1) == '-'
                sn_comb = [sn_comb ' ' sn{ii}];
            else
                sn_comb = [sn_comb ' + ' sn{ii}];
            end
        end
    end
end
sout = str2sym(sn_comb);
end
