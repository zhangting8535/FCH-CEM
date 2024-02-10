% By Zhang Ting modify 2022/11/6

function [elecmodel, impedance_error] = assemble_elecmodel(headmodel, elec_template, cfg)

% single electrode
% input: headpos------head model position;
%           elec_template------electrode tmplate, get the center
%           cfg----.loadtype(for example: 'Fp1'); .type: electrode shape;
%           .diameter  ---- belong to round;
%            .diameter_inner, .diameter_outer---belong to annulus
% output: Pe , Te, P, center, type, typelabel, impedance

%% 
isauto = cfg.auto;
study_elec_loadtype = cfg.loadtype;
elecname = fullfile(cfg.cempath,['lambda',num2str(cfg.lambda)],sprintf('%s_%s_%d%s','elec', study_elec_loadtype,cfg.size(2),'.mat'));
if exist(elecname , 'file')
    if isauto ==1
        % auto model: load
        isload = 1;
    else
        disp(elecname)
        isload = input ('Directly loading? [1-yes / 0-no]');
    end
    
    if isload == 1
        load(elecname)
        impedance_error = pi*(cfg.size(2)/2)^2-sum(elecmodel.cond_scem);
%         return
    end
end

%% 0. get initial setting
study_elec_loadtype = cfg.loadtype;
center = elec_template.elecpos(strcmp(elec_template.label, study_elec_loadtype), :);    % find the electrode position
% disp(center)
%% 1. get all boundary elements
bntfile = fullfile(cfg.bndpath, 'boundary.mat');
if ~exist(bntfile,'file')
    disp('searching the boundary!')
    boundary = search_boundary_v3(headmodel);
    save(bntfile, 'boundary')
else
    load(bntfile)
end

%%  2. get electrode boundary
indx = dsearchn(boundary.Pb(:,2:4),center);
center = boundary.Pb(indx,:);
center = center(2:4);
% disp(['center', num2str(center)])
[Pe, Te] = get_Pe_Te(boundary, center, cfg);
loadtype = study_elec_loadtype;

%% compute cond
cond_scem = zeros(size(Te,1),1);  % sCEM
% setting min z-coordinate node to the x-axis direction
[~,min_z_indx] = min(Pe(:,4));
direction = Pe(min_z_indx,2:4)-center;
direction = direction/norm(direction);
%
for i = 1:size(Te,1)
    cond_scem(i) =  compute_cond(cfg.size(2), center,direction, headmodel.pos(Te(i,:),:), 'sCEM','offCenterTriangle',cfg.lambda,cfg.r);
end

%% 3. assemble electrode model 
elecmodel.Pe = Pe;
elecmodel.Te = Te;
elecmodel.P = headmodel.pos;
elecmodel.center = center;
elecmodel.loadshape = loadtype;
elecmodel.load = find(ismember(elec_template.label,loadtype));
elecmodel.shape = cfg.shape;
elecmodel.cond_scem = cond_scem;
impedance_error = pi*(cfg.size(2)/2)^2-sum(cond_scem);
% save(elecname, 'elecmodel')
end

