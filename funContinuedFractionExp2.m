%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2024-2-25(yyyy-mm-dd)
% 连分式展开
%--------------------------------------------------------------------------
function [km, Type, PS] = funContinuedFractionExp2(n, d, mode, varargin)
% 辗转相除算法
if nargin<3
    mode = 'CauerI';
end
m_n = length(n);
m_d = length(d);
Type = [];% 器件类型
PS   = [];% 连接类型
switch mode
    case 'CauerI'
        if m_n-m_d==1
            d = [0,d];
            for ii=1:m_d
                if mod(ii, 2)
                    Type{ii} = 'L';
                    PS{ii}   = 'S';
                else
                    Type{ii} = 'C';
                    PS{ii}   = 'P';
                end
                km(ii)    = n(ii)/d(ii+1);
                n = n-km(ii).*[d(2:end),0];
                t = n;
                n = d;
                d = t;
            end
        else
        end
    case 'CauerII'
        if m_n-m_d==1
            d = [0,d];
            d = fliplr(d);
            n = fliplr(n);
            for ii=1:m_d
                if mod(ii, 2)
                    Type{ii} = 'C';
                    PS{ii}   = 'S';
                else
                    Type{ii} = 'L';
                    PS{ii}   = 'P';
                end
                km(ii)    = d(ii+1)/n(ii);
                n = n-1/km(ii).*[d(2:end),0];
                t = n;
                n = d;
                d = t;
            end
        else
        end
    case 'FosterI'
    case 'FosterII'
end
