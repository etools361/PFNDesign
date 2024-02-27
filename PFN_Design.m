%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2024-2-25(yyyy-mm-dd)
% PFN calculator
% All types of networks
%--------------------------------------------------------------------------
delta   = 1;
epsilon = 0.13;
n       = 9;
t = linspace(-1, 1, 1000);
syms x yy;
y   = funSquare2(t, delta, epsilon);
N   = (n+1)/2;
yf  = 0;
yf2 = 0;
x0  = t/epsilon;
yy  = 0;
a   = delta/epsilon;
fprintf('-----------Type C------------\n');
% F1 = [];
% A1 = [];
for ii=1:2:n
    an = 4/(ii*pi)*(sin(ii*pi/2/a)/(ii*pi/2/a))^2;
    yy = 1/(x/(an*ii)+ii/(x*an))+yy;
%     F1(length(F1)+1) = ii;
%     A1(length(A1)+1) = 1/an;
    fprintf('C_%d:%0.5f;\tL_%d:%0.5f;\n', (ii+1)/2, an/ii, (ii+1)/2, 1/(an*ii));
    yf = yf + an.*sin(ii*pi*x0/a);
%     yf2 = yf2 + 4/(ii*pi)*sin(ii*pi*x0/a);
end
% y0 = subs(x/yy, x, x^(1/2));
y0 = 1/yy;
s = partfrac(y0,x,'FactorMode', 'real');
[s3] = funSplitPartfrac(s);
%----------------------------------------
fprintf('-----------Type A------------\n');
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
        fprintf('C_1=%0.6fF\n', C0);
    elseif length(cn)==2&&length(cd)==1
        % L
        L0 = cn(1)/cd(1);
        fprintf('L_1=%0.6fH\n', L0);
    elseif length(cn)==2&&length(cd)==3
        L = cn(1)/cd(3);
        C = cd(1)/cd(3)/L;
        LL(length(LL)+1) = L;
        CC(length(CC)+1) = C;
        A2(length(A2)+1) = sqrt(L/C);
        fprintf('C_%d:%0.5f;\tL_%d:%0.5f;\n', length(CC)+1, C, length(LL)+1, L);
    end
end
% for ii=1:length(F1)
%     fprintf('F1%d=%0.3fRad/s\n', ii, F1(ii));
% end
% for ii=1:length(A1)
%     fprintf('A1_%d=%0.3f\n', ii, A1(ii));
% end
% for ii=1:length(LL)
%     fprintf('Freq%d=%0.3fRad/s\n', ii, 1/(sqrt(LL(ii)*CC(ii))));
% end
% for ii=1:length(A2)
%     fprintf('A2_%d=%0.3f\n', ii, A2(ii));
% end
%---------------------------------------------------------
fprintf('-----------Testing------------\n');
delta2 = 100e-9;
R = 50;
fprintf('Delta=%s s\n', Data2Suffix(delta2,'0.3'));
fprintf('R=%s Ohm\n', Data2Suffix(R,'0.3'));
L0p = eval(vpa(L0*delta2/pi*R));
fprintf('L_0=%s H\n', Data2Suffix(L0p,'0.3'));
C0p = eval(vpa(C0*delta2/pi/R));
fprintf('C_0=%s F\n', Data2Suffix(C0p,'0.3'));
for ii=1:length(CC)
    Cp = eval(vpa(CC(ii)*delta2/pi/R));
    Lp = eval(vpa(LL(ii)*delta2/pi*R));
    fprintf('C_%d:%s F;\tL_%d:%s H;\n', ii, Data2Suffix(Cp,'0.3'), ii, Data2Suffix(Lp,'0.3'));
end

[nn,d]=numden(y0);
cn = coeffs(nn, 'all');
cd = coeffs(d, 'all');
cn = vpa(cn./cd(1));% 分子系数
cd = vpa(cd./cd(1));% 分母系数
[km1, Type1, PS1] = funContinuedFractionExp2(eval(cn), eval(cd), 'CauerI');
[km2, Type2, PS2] = funContinuedFractionExp2(eval(cn), eval(cd), 'CauerII');
%---------------------------------------------------------
fprintf('---------Type B(CauerI)--------------\n');
for ii=1:N
    fprintf('C_%d:%s F;\tL_%d:%s H;\n', ii, Data2Suffix(km1(2*ii),'0.3'), ii, Data2Suffix(km1(2*ii-1),'0.3'));
end
fprintf('---------Type F(CauerII)--------------\n');
for ii=1:N
    fprintf('C_%d:%s F;\tL_%d:%s H;\n', ii, Data2Suffix(km2(2*ii-1),'0.3'), ii, Data2Suffix(km2(2*ii),'0.3'));
end
fprintf('----------Type D-------------\n');
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
for ii=1:N
    if ii<N
        fprintf('C_%d:%s F;\tL1_%d:%s H\tL_%d:%s H;\n', ii, Data2Suffix((Cn(ii)),'0.3'), ii, Data2Suffix((Ln1(ii)),'0.3'), ii, Data2Suffix((Ln(ii)),'0.3'));
    else
        fprintf('C_%d:%s F;\tL1_%d+L_%d:%s H\n', ii, Data2Suffix((Cn(ii)),'0.3'), ii, ii, Data2Suffix((Ln1(ii)),'0.3'));
    end
end
fprintf('----------Type E-------------\n');
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
for ii=1:N
    if ii<N
        fprintf('C_%d:%s F;\tL1_%d:%s H\tk_%d:%s;\n', ii, Data2Suffix((Cn(ii)),'0.3'), ii, Data2Suffix((L_E(ii)),'0.3'), ii, Data2Suffix((k_E(ii)),'0.3'));
    else
        fprintf('C_%d:%s F;\tL1_%d:%s H\n', ii, Data2Suffix((Cn(ii)),'0.3'), ii, Data2Suffix((L_E(ii)),'0.3'));
    end
end

% plot
plot(t, y, '-b', 'linewidth', 1);
hold on;
plot(t, yf, '-r', 'linewidth', 2);
hold off;
grid on;
xlabel('time/s');
ylabel('Vo');
title(sprintf('PFN, n=%d, \\epsilon =%0.3f', n, epsilon));



