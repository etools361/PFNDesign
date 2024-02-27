%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2024-2-25(yyyy-mm-dd)
% PFN design function
%--------------------------------------------------------------------------
function [coeffAll, epsilon] = funPFNDesign(n)
if n<5
    coeffAll = [];
    epsilon  = [];
    return;
end
epsTab = [0.5,0.25,0.18,0.14,0.13, 0.11, 0.09, 0.08, 0.07, 0.06];
% epsTab = [0.5,0.25,0.18,0.14,0.13, 0.08, 0.09, 0.08, 0.07, 0.06];
epsilon = epsTab(fix((n+1)/2));%n=5,7,9,...
delta   = 1;
% n       = 9;
% t = linspace(-1, 1, 1000);
syms x yy;
% y   = funSquare2(t, delta, epsilon);
N   = (n+1)/2;
% yf  = 0;
% yf2 = 0;
% x0  = t/epsilon;
yy  = 0;
a   = delta/epsilon;
% fprintf('-----------Type C------------\n');
% F1 = [];
% A1 = [];
coeffAll = [];
for ii=1:2:n
    an = 4/(ii*pi)*(sin(ii*pi/2/a)/(ii*pi/2/a))^2;
    yy = 1/(x/(an*ii)+ii/(x*an))+yy;
    iii = (ii+1)/2;
    coeffAll.TypeC.C(iii) = an/ii;
    coeffAll.TypeC.L(iii) = 1/(an*ii);
%     F1(length(F1)+1) = ii;
%     A1(length(A1)+1) = 1/an;
%     fprintf('C_%d:%0.5f;\tL_%d:%0.5f;\n', (ii+1)/2, an/ii, (ii+1)/2, 1/(an*ii));
%     yf = yf + an.*sin(ii*pi*x0/a);
%     yf2 = yf2 + 4/(ii*pi)*sin(ii*pi*x0/a);
end
% y0 = subs(x/yy, x, x^(1/2));
y0 = 1/yy;
s = partfrac(y0,x,'FactorMode', 'real');
[s3] = funSplitPartfrac(s);
%----------------------------------------
% fprintf('-----------Type A------------\n');
m_s3 = length(s3);
LL = [];
CC = [];
A2 = [];
for ii=1:m_s3
    s4 = str2sym(s3{ii});
    [nn,d]=numden(s4);
    cn = vpa(coeffs(nn, 'all'));
    cd = vpa(coeffs(d, 'all'));
    if length(cn)==1&&length(cd)==2
        C0 = cd(1)/cn(1);
%         fprintf('C_1=%0.6fF\n', C0);
    elseif length(cn)==2&&length(cd)==1
        % L
        L0 = cn(1)/cd(1);
%         fprintf('L_1=%0.6fH\n', L0);
    elseif length(cn)==2&&length(cd)==3
        L = cn(1)/cd(3);
        C = cd(1)/cd(3)/L;
        LL(length(LL)+1) = L;
        CC(length(CC)+1) = C;
        A2(length(A2)+1) = sqrt(L/C);
%         fprintf('C_%d:%0.5f;\tL_%d:%0.5f;\n', length(CC)+1, C, length(LL)+1, L);
    end
end
[a, b] = sort(CC);
coeffAll.TypeA.C = eval([C0, a]);
coeffAll.TypeA.L = eval([L0, LL(b)]);

[nn,d]=numden(y0);
cn = coeffs(nn, 'all');
cd = coeffs(d, 'all');
cn = vpa(cn./cd(1));% 分子系数
cd = vpa(cd./cd(1));% 分母系数
[km1, Type1, PS1] = funContinuedFractionExp2(eval(cn), eval(cd), 'CauerI');
[km2, Type2, PS2] = funContinuedFractionExp2(eval(cn), eval(cd), 'CauerII');
%---------------------------------------------------------
% fprintf('---------Type B(CauerI)--------------\n');
% for ii=1:N
%     fprintf('C_%d:%s F;\tL_%d:%s H;\n', ii, Data2Suffix(km1(2*ii),'0.3'), ii, Data2Suffix(km1(2*ii-1),'0.3'));
% end
coeffAll.TypeB.C = km1(2*(1:N));
coeffAll.TypeB.L = km1(2*(1:N)-1);
% fprintf('---------Type F(CauerII)--------------\n');
% for ii=1:N
%     fprintf('C_%d:%s F;\tL_%d:%s H;\n', ii, Data2Suffix(km2(2*ii-1),'0.3'), ii, Data2Suffix(km2(2*ii),'0.3'));
% end
coeffAll.TypeF.C = km2(2*(1:N)-1);
coeffAll.TypeF.L = km2(2*(1:N));
% fprintf('----------Type D-------------\n');
C0 = sum(km1(2:2:end))/N;
yt = y0;
Ln1 = [];
Ln  = [];
la  = [];
Cn  = [];
for ii=1:N-1
    S0 = x^3/2*diff(yt/x);
    la(ii) = vpasolve(S0+1/C0,x,[0,inf]);
    Ln1(ii) = subs(yt/x,x,la(ii));
    Ln(ii) = -1/(C0*la(ii)^2);
    Cn(ii) = C0;
    ytt = 1/(1/(yt-Ln1(ii)*x)-1/(1/(x*C0)+x*Ln(ii)));
    s2 = partfrac(ytt,x,'FactorMode', 'real');
    [yt] = funRmPartfrac(s2, 1e-5);
end
[nn, d] = numden(yt);
co = coeffs(nn, 'all');
if length(co) == 3
    Ln1(N) = co(1);
    Cn(N)  = 1/co(3);
else
    fprintf('Error\n');
end
% for ii=1:N
%     if ii<N
%         fprintf('C_%d:%s F;\tL1_%d:%s H\tL_%d:%s H;\n', ii, Data2Suffix((Cn(ii)),'0.3'), ii, Data2Suffix((Ln1(ii)),'0.3'), ii, Data2Suffix((Ln(ii)),'0.3'));
%     else
%         fprintf('C_%d:%s F;\tL1_%d+L_%d:%s H\n', ii, Data2Suffix((Cn(ii)),'0.3'), ii, ii, Data2Suffix((Ln1(ii)),'0.3'));
%     end
% end
coeffAll.TypeD.C = Cn;
coeffAll.TypeD.L = Ln1;
coeffAll.TypeD.M = Ln;
% fprintf('----------Type E-------------\n');
L_E = [];
k_E = [];
for ii=1:N
    if ii==1
        L_E(ii) = Ln1(ii)+Ln(ii);
    elseif ii==N
        L_E(ii) = Ln1(ii)+Ln(ii-1);
        k_E(ii-1) = -Ln(ii-1)./sqrt(L_E(ii)*L_E(ii-1));
    else
        L_E(ii) = Ln1(ii)+Ln(ii-1)+Ln(ii);
        k_E(ii-1) = -Ln(ii-1)./sqrt(L_E(ii)*L_E(ii-1));
    end
end
% for ii=1:N
%     if ii<N
%         fprintf('C_%d:%s F;\tL1_%d:%s H\tk_%d:%s;\n', ii, Data2Suffix((Cn(ii)),'0.3'), ii, Data2Suffix((L_E(ii)),'0.3'), ii, Data2Suffix((k_E(ii)),'0.3'));
%     else
%         fprintf('C_%d:%s F;\tL1_%d:%s H\n', ii, Data2Suffix((Cn(ii)),'0.3'), ii, Data2Suffix((L_E(ii)),'0.3'));
%     end
% end
coeffAll.TypeE.C = Cn;
coeffAll.TypeE.L = L_E;
coeffAll.TypeE.k = k_E;

% % plot
% plot(t, y, '-b', 'linewidth', 1);
% hold on;
% plot(t, yf, '-r', 'linewidth', 2);
% hold off;
% grid on;
% xlabel('time/s');
% ylabel('Vo');
% title(sprintf('PFN, n=%d, \\epsilon =%0.3f', n, epsilon));
end