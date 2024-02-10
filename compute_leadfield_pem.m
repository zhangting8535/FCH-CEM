% By Zhang Ting 2022/9/13
% PEM electrode model
% Neumann condition

function [L_pem,transfer] = compute_leadfield_pem(headmodel,elecmodel,sourcemodel)

elec_num = size(elecmodel.elecpos,1);
pnum = size(headmodel.pos,1);
% 1. compute transfer
A = headmodel.stiff;
tic
B = zeros(pnum,elec_num);
for i = 1:elec_num
    % construct b vector
    indx = find(ismember(headmodel.pos,elecmodel.elecpos(i,:),'rows'));
    b = B(:,i); 
    b(indx) = 1;   % average reference
%     dirinode = B(:,i);
%     dirinode(ismember(headmodel.pos,elecmodel.elecpos(1,:),'rows')) = 1;v
%     
%     dirival = B(:,i);
%     [A,b] = sb_set_bndcon(A,b,dirinode,dirival);    
    B(:,i)=b;
end
T = sb_solve_self(A, B);
R = eye(elec_num) - ones(elec_num,elec_num)/elec_num;
transfer = R*T';
headmodel.transfer = transfer;

% 2. compute leadfield
if isfield(sourcemodel,'Gx')
    try
        lx = transfer*sourcemodel.Gx;
        ly = transfer*sourcemodel.Gy;
        lz = transfer*sourcemodel.Gz;
        lf = [lx(:),ly(:),lz(:)];   % Î¬¶È£º£¨elecnum* sourcenum£©*3)
        lf =  mat2cell(lf,enum*ones(snum,1),3);
    catch
        pause('on')
        pause(300)
        sound_matlab(4)
    end
else
    lf = assemble_lf_with_source(headmodel,sourcemodel.pos(sourcemodel.index,:));
end

% 3. assemble L
L_pem.pos = sourcemodel.pos;
L_pem.tri = sourcemodel.tri;
L_pem.inside = sourcemodel.inside;
L_pem.index = sourcemodel.index;
L_pem.leadfield = lf ;
L_pem.norm = sourcemodel.norm;
end