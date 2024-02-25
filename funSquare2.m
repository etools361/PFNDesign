%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2024-2-13(yyyy-mm-dd)
% 方波
%--------------------------------------------------------------------------
function y = funSquare2(t, delta, epsilon)
    n = length(t);
    for ii=1:n
        t0 = mod(t(ii), 2*delta);
        if t0>=0 && t0<epsilon
            y(ii) = t0/epsilon*(2-t0/epsilon);
        elseif t0>=epsilon && t0<delta-epsilon
            y(ii) = 1;
        elseif t0>=epsilon-epsilon && t0<delta
            y(ii) = (t0/epsilon-delta/epsilon)*(delta/epsilon-2-t0/epsilon);
        elseif t0>=delta && t0<delta+epsilon
            y(ii) = -(t0/epsilon-delta/epsilon)*(delta/epsilon+2-t0/epsilon);
        elseif t0>=delta+epsilon && t0<2*delta-epsilon
            y(ii) = -1;
        elseif t0>=2*delta-epsilon && t0<2*delta
            y(ii) = -(t0/epsilon-2*delta/epsilon)*(2*delta/epsilon-2-t0/epsilon);
        else
            fprintf('error:ii=%d,t0=%0.3f\n', ii, t0);
        end
    end
end