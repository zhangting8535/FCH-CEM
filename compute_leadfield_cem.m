% By Zhang Ting 2022/9/9

function [L_cem,time_cost] = compute_leadfield_cem(headmodel, sourcemodel, cfg)

elecnum = length(cfg.loadtype);
tmp = zeros(elecnum, size(headmodel.pos,1));
R = eye(elecnum) - ones(elecnum,elecnum)/elecnum;  
B = tmp';
C = zeros(elecnum);
s1 = tic;
for k = 1:elecnum
     % get A B C G 
     currentelec = importdata(fullfile(cfg.cempath,['lambda',num2str(cfg.lambda)],sprintf('%s_%s_%d%s','elec', eleclabel{k},cfg.size(2),'.mat')));
     [stiff, B(:,k), C(k,k)] = treat_CE_bnd(stiff, currentelec, cfg.cemtype,cfg.impedance);
end
time_end1 = toc(s1);
%delete upper triangle value
[indxi,indxj,s] = find(stiff);
clear stiff
up_tri_indx = find(indxi<indxj);
indxi(up_tri_indx) = [];
indxj(up_tri_indx) = [];
s(up_tri_indx) = [];
A = sparse(indxi,indxj,s,stiff_dim,stiff_dim);
disp(['A, B, C has been assembled-----cost time: ',num2str(time_end1/60), 'min'])
% compute T
s2 = tic;
T = sb_solve_self(A,B,cfg.cemtype,cfg.size,cfg.impedance);
time_cost = toc(s2);
sound_matlab(8)
transfer = R*((T'*B - C)\T');  
try
    if strcmp(cfg.cemtype, 'CEM') == 1
        transfername = fullfile(LfPath, 'cem', sprintf('transfer_CEM_%d_%d_%d.mat', cfg.size(2), cfg.basic, log10(cfg. impedance / cfg.basic)));
    else
        transfername = fullfile(LfPath, ['lambda',num2str(cfg.lambda)], sprintf('transfer_sCEM_%d_%d_%d.mat', cfg.size(2), cfg.basic, log10(cfg. impedance /cfg.basic)));
    end
    save (transfername, 'T')    
catch
    sound_matlab(4)
    pause('on')
    pause(300)
end
clear A tmp

%% 2. get leadfield
if isfield(sourcemodel,'Gx')
    lx = transfer*sourcemodel.Gx;
    ly = transfer*sourcemodel.Gy;
    lz = transfer*sourcemodel.Gz;
    lf = [lx(:),ly(:),lz(:)];   % （elecnum* sourcenum）*3
    lf =  mat2cell(lf,elecnum*ones(size(sourcemodel.Gx,2),1),3);
else
    lf = assemble_lf_with_source(headmodel,sourcemodel.pos(sourcemodel.index,:));
end
% 3. assemble L
L_cem.pos = sourcemodel.pos;
L_cem.tri = sourcemodel.tri;
L_cem.inside = sourcemodel.inside;
L_cem.leadfield = lf ;
L_cem.index = sourcemodel.index;
L_cem.norm = sourcemodel.norm;
end