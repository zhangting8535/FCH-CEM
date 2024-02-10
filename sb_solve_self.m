% By Zhang Ting 2022/9/10
% Referring to the function (named "sb_solve") of the fieldtrip-simbio toolkit

function result = sb_solve_self(sysmat,B,electype,elesize,impedance)
% $Id$
%scalen
disp('Scaling stiffness matrix...')
dkond = 1./(sqrt(diag(sysmat)));
[indexi, indexj, s] = find(sysmat);
sys_size = size(sysmat,1); 
clear sysmat;
s = (s.*dkond(indexi)).*dkond(indexj);
s(1) = 1;
disp('Preconditioning...')
L = sparse(indexi,indexj,s,sys_size,sys_size,length(s));
%partch
try
    options.type = 'nofill';
    options.michol = 'on';
    L = ichol(L,options);
catch
    disp('Could not compute incomplete Cholesky-decompositon. Rescaling stiffness matrix...')
    alpha = 0.5d-6;
    alpha = alpha*8.d0;
    alpha = 1 / (alpha + 1);
    s = alpha*s;
    dia = find(indexi == indexj);
    s(dia) = (1./alpha)*s(dia);
    s(dia) = sqrt(s(dia));
    s(1) = 1;
    L = sparse(indexi,indexj,s,sys_size,sys_size,length(s));
    clear dia;
    L = chol(L);
end
result = zeros(size(B,1),size(B,2));
rr_list = zeros(size(B,2),1);
% CoreNum=1; %设定机器CPU核心数量
% if isempty(gcp('nocreate')) %如果并行未开启
%     parpool(CoreNum);
% end
for i = 1:size(B,2)
    disp(['Compute transfer:  [ ',num2str(i),' / ',num2str(size(B,2)),' ]',' electrode']);
    vecb = B(:,i);
    vecb = vecb.*dkond;
    %startvektor
    disp('Finding startvector...')
    vecb_ = L \ (-vecb);
    vecx = L' \ vecb_;
%     clear vecb_;
    %sonstiges
    sysmat = sparse(indexi,indexj,s,sys_size,sys_size,length(s));
    sysmat = sysmat + sysmat' - sparse(1:sys_size,1:sys_size,diag(sysmat),sys_size,sys_size,sys_size);
%     clear indexi indexj s;
    %dprod = sysmat * vecx;
    %l?sen
    disp('Solving equation system...')
    [x,fl,rr,it,rv]= pcg(sysmat,vecb,10e-9,50000,L,L',vecx);
    %fl
    rr
    rr_list(i) = rr;
    %it
    %rescal
    result(:,i) = x.*dkond;
end
try
    if nargin<3
        electype = 'pem';
        rrname = fullfile('E:\0--Experiments\MyItems\EegElectrode\CEM_v4\Data\LiuYan\leadfield\error',sprintf('%s_%s.%s','rr_list',electype,'mat'));
    elseif nargin == 5
        rrname = fullfile('E:\0--Experiments\MyItems\EegElectrode\CEM_v4\Data\LiuYan\leadfield\error',sprintf('%s_%d_%s_%d.%s','rr_list',elesize(2),electype,impedance,'mat'));
    end
    save(rrname,'rr_list')
catch
    disp('save rr_list code exist wrong, check check~~~~~')
    save('rr_list.mat','rr_list')
end
end