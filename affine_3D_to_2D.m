% By Zhang Ting 2022/09/14

%{
model:  target_pos*T = vertices*E;

compute the volume of a qaud element
                       v1------v4
                       /      /
                    v2------v3
%}
% Vx = (vertice(2,:) - vertice(1,:)) / norm(vertice(2,:) - vertice(1,:));
% Vz = cross(vertice(2,:) - vertice(1,:), vertice(3,:) - vertice(1,:)) ;
% Vy = cross(Vz, Vx);
% T1 = [[Vx',Vy',Vz';[0 0 0]],[0; 0; 0; 1]];   % ransform the coordinate
% % T2 = [[eye(3);center],[0;0;0;1]];
% T = inv(T1);
% target_pos = [vertice,ones(size(vertice,1),1)]*T;

function [target_pos,invT] = affine_3D_to_2D(vertice)

center = mean(vertice);
Vz = cross(vertice(2,:) - vertice(1,:), vertice(3,:) - vertice(1,:)) ;
% Vz = sign(Vz*center')*Vz;   % not related to the norm direction, so not
% need this pice of code
Vx = ( mean(vertice(3:4,:)) - center) / norm(mean(vertice(3:4,:)) - center);
Vy = cross(Vz, Vx);
T = [[Vx;Vy;Vz;[0 0 0]],[0; 0; 0; 1]];

% T = [[Vx;Vy;Vz;center],[0; 0; 0; 1]];
invT = inv(T);
target_pos = [vertice,ones(size(vertice,1),1)]*invT;
if abs(target_pos(:,3) - mean(target_pos(:,3))) < 1e-8
    target_pos = target_pos(:,1:2);
else
    error('compute error: code error!')
end   % check z-axis is the same or not: the error tolerate is 1e-8