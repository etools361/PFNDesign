%--------------------------------------------------------------------------
% Edited by bbl
% Date: 2024-2-25(yyyy-mm-dd)
% PFN calculator
% Generate coeff
%--------------------------------------------------------------------------
% n = 3:10;
n = 5;
strName = './PFNCoeff.dat';
m = length(n);
coeffAll = [];
for ii=1:m
    [coeffAll{ii}, epsTab(ii)] = funPFNDesign(n(ii)*2-1);
end

fid = fopen(strName, 'w');
strSave = sprintf('// for PFN design, PFN coeff\n// %s', datestr(clock, 31));
for ii=1:m
    strSave = sprintf('%s\n\nn:%d\nepsilon:%0.3f',strSave, n(ii)*2-1, epsTab(ii));
    % TypeA
    strSave = sprintf('%s\nTypeA',strSave);
    TypeA = coeffAll{ii}.TypeA;
    strC  = sprintf('%0.6e,', TypeA.C);
    strSave = sprintf('%s\nC:%s',strSave, strC(1:end-1));
    strL  = sprintf('%0.6e,', TypeA.L);
    strSave = sprintf('%s\nL:%s',strSave, strL(1:end-1));
    % TypeB
    strSave = sprintf('%s\nTypeB',strSave);
    TypeB = coeffAll{ii}.TypeB;
    strC  = sprintf('%0.6e,', TypeB.C);
    strSave = sprintf('%s\nC:%s',strSave, strC(1:end-1));
    strL  = sprintf('%0.6e,', TypeB.L);
    strSave = sprintf('%s\nL:%s',strSave, strL(1:end-1));
    % TypeC
    strSave = sprintf('%s\nTypeC',strSave);
    TypeC = coeffAll{ii}.TypeC;
    strC  = sprintf('%0.6e,', TypeC.C);
    strSave = sprintf('%s\nC:%s',strSave, strC(1:end-1));
    strL  = sprintf('%0.6e,', TypeC.L);
    strSave = sprintf('%s\nL:%s',strSave, strL(1:end-1));
    % TypeD
    strSave = sprintf('%s\nTypeD',strSave);
    TypeD = coeffAll{ii}.TypeD;
    strC  = sprintf('%0.6e,', TypeD.C);
    strSave = sprintf('%s\nC:%s',strSave, strC(1:end-1));
    strL  = sprintf('%0.6e,', TypeD.L);
    strSave = sprintf('%s\nL:%s',strSave, strL(1:end-1));
    strM  = sprintf('%0.6e,', TypeD.M);
    strSave = sprintf('%s\nM:%s',strSave, strM(1:end-1));
    % TypeE
    strSave = sprintf('%s\nTypeE',strSave);
    TypeE = coeffAll{ii}.TypeE;
    strC  = sprintf('%0.6e,', TypeE.C);
    strSave = sprintf('%s\nC:%s',strSave, strC(1:end-1));
    strL  = sprintf('%0.6e,', TypeE.L);
    strSave = sprintf('%s\nL:%s',strSave, strL(1:end-1));
    strk  = sprintf('%0.6e,', TypeE.k);
    strSave = sprintf('%s\nk:%s',strSave, strk(1:end-1));
    % TypeF
    strSave = sprintf('%s\nTypeF',strSave);
    TypeF = coeffAll{ii}.TypeF;
    strC  = sprintf('%0.6e,', TypeF.C);
    strSave = sprintf('%s\nC:%s',strSave, strC(1:end-1));
    strL  = sprintf('%0.6e,', TypeF.L);
    strSave = sprintf('%s\nL:%s',strSave, strL(1:end-1));
end
fwrite(fid, strSave);
fclose(fid);


