function [Pe, Te] = get_Pe_Te(boundary, center, cfg)

type = cfg.shape;
elecenter  = get_element_center(boundary.P,boundary.Tb);
%%  get element from headmodel
if strcmp(type,'round') ==1
    radius = cfg.size(2)/2;
    Te = boundary.Tb((sum((elecenter - center).^2, 2) <= radius^2), :);
    
elseif strcmp(type,'squre') ==1 
    side = cfg.side(2);
    elec_area = [center - side/2; center + side/2];
    Te = boundary.Tb(elecenter(:,1)>=elec_area(1,1) & elecenter(:,1)<=elec_area(2,1)...
        &elecenter(:,2)>=elec_area(1,2) & elecenter(:,2)<=elec_area(2,2)...
        &elecenter(:,3)>=elec_area(1,3) & elecenter(:,3)<=elec_area(2,3),:);

elseif strcmp(type,'annulus') ==1 
    radius_inner = min(cfg.size(1),cgf.size(2));
    radius_outer = max(cfg.size(1),cgf.size(2));
    Te = boundary.Tb((sum((elecenter  - center).^2, 2) <= radius_outer^2 ...
        & sum((elecenter - center).^2, 2) >= radius_inner^2), :);
        
elseif isfield(cfg, 'shape')
    error('Only suport£º round, annulus and squre!')
else
    error('Please input electrode shape type!')
end
%% get the pos from element
indx = unique(Te(:));
Pe = boundary.P(indx,:);
Pe = [find(ismember(boundary.P, Pe, 'rows')),Pe];

function elecenter = get_element_center(P,T)
elecenter = zeros(size(T,1),3);
for i = 1:size(T,1)
    elecenter(i,:) = mean(P(T(i,:),:));
end
end

end
