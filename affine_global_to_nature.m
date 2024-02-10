% By Zhang Ting 2022

function [vh, T] = affine_global_to_nature(affine_pos, vertices, shape)
% T : transform matrix from global to nature
% affine_pos: N*3
% vertices: M*3

if strcmp(shape, 'hex') == 1
    % 3D
    direction_x = vertices(2,:) - vertices(1,:);
    direction_y = vertices(4,:) - vertices(1,:);
    direction_z = vertices(5,:) - vertices(1,:);
    center = mean(vertices);
    h1 = norm(direction_x);
    h2 = norm(direction_y);
    h3 = norm(direction_z);
    T1 = [[direction_x/h1;direction_y/h2;direction_z/h3;[0 0 0]],[0;0;0;1]];   %coordinary transform
    T2 = [h1/2 0 0 0; 0 h2/2 0 0; 0 0 h3/2 0; [center,1]];  % scale transform
    T = inv(T1*T2);  
    vh = [affine_pos, ones(size(affine_pos,1),1)] * T;   
    vh = vh(:,1:3);  
elseif strcmp(shape, 'qaud') == 1
    % 2D
    direction_x = vertices(3,:) - vertices(2,:);
    direction_y = vertices(1,:) - vertices(2,:);
    center = mean(vertices);
    h1 = norm(direction_x);
    h2 = norm(direction_y);
    T1 = [[[direction_x/h1;direction_y/h2;];[0 0]],[0; 0; 1]];   
    T2 = [h1/2 0 0 ; 0 h2/2 0; [center,1]];   
    T = inv(T1*T2);
    vh = [affine_pos, ones(size(affine_pos,1),1)]*T;  
    vh = vh(:,1:2);
end
