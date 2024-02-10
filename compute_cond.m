% By Zhang Ting, Modify at 2022/10/21

function cond = compute_cond(d, center,direction, pos, type,condtype,value,r)
% pos--position of qaudra element belong to the face
% center--the center of electrode
% 4/
impedance = 1;  % unit: when using, should* 1/zl
if strcmp(type, 'sCEM')
    switch condtype
        case 'isoscelesTriangle'
            cond = 4*impedance/d*(d/2 - norm(mean(pos) - center));
        case 'offCenterTriangle'
            targetpos = mean(pos);
            offCenter = value;
            cond = compute_cond_offCenterTriangle(impedance,center,d,offCenter,targetpos,direction,r);
        case 'annulus'
    end
elseif strcmp(type, 'CEM')
    cond = 1/impedance;
else
    error('Permission complete electrode type is sCEM or CEM, please inpute right type!')
end