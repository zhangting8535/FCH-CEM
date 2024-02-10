% By Zhang Ting 2022/9/9

function [Gauss_coe_loc,Gauss_pos_loc]=generate_Gauss_loc_quad(Gauss_coe_ref,Gauss_pos_ref,vertices)

% compute transform matrix: vh = f(v) = v*T
[~, T] = affine_global_to_nature(Gauss_pos_ref, vertices, 'qaud');

% 2. affine reference to local
Gauss_coe_loc=Gauss_coe_ref/ abs(det(T));
interval = [Gauss_pos_ref, ones(size(Gauss_pos_ref,1),1)] / T;    % 中间储存值，没啥特殊用意
Gauss_pos_loc = interval(:, 1:2);