% By Zhang Ting 2022/9/9   modified by 2022/11/06

function result = loc_basis_quad(compute_pos, vertices, basis_type, basis_index, der_x, der_y, eleshape)
% compute_pos: mesh nodes positions
% vertices：
% basis_type：first-order finite element / second-order finite element
% basis_index：the index of current position
% der_x:  the degree of partial derivative with respect to x
% der_y:  the degree of partial derivative with respect to y
[vh,T] = affine_global_to_nature(compute_pos, vertices, eleshape);
xh = vh(1); yh = vh(2);
J = T(1:2,1:2);
J= J';
if der_x ==0 && der_y ==0
    % scalar
    result = ref_basis_quad(xh,yh, basis_type, basis_index, der_x, der_y);
    
elseif der_x ==1 && der_y ==0
    % scalar
    result = [ref_basis_quad(xh,yh, basis_type, basis_index, 1, 0);...
        ref_basis_quad(xh,yh, basis_type, basis_index, 0, 1)] * J(:,1);
    
elseif der_x ==0 && der_y ==1
    % scalar
    result = [ref_basis_quad(xh,yh, basis_type, basis_index, 1, 0);...
        ref_basis_quad(xh,yh, basis_type, basis_index, 0, 1)] * J(:,2);
    
elseif der_x ==1 && der_y ==1
    % vector: 1*2
    result = [ref_basis_quad(xh,yh, basis_type, basis_index, 1, 0);...
        ref_basis_quad(xh,yh, basis_type, basis_index, 0, 1)] * J;
end
