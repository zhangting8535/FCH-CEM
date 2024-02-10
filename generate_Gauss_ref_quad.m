% By Zhang Ting 2022/9/9
% Generate the Gauss coefficients and Gauss points on the reference triangle whose vertices are (0,0),(1,0),(0,1)
% Gauss_point_number:the number of Gauss points in the formula. The Gauss formula depends on it.
% Gauss_coefficient_reference_triangle,Gauss_point_reference_triangle: the Gauss coefficients and Gauss points on the reference triangle

function [Gauss_coe_ref,Gauss_pos_ref]=generate_Gauss_ref_quad(Gauss_point_number)

if Gauss_point_number==4
    Gauss_coe_ref=ones(4,1);
    Gauss_pos_ref=1/sqrt(3)*[-1 1; -1 -1; 1 -1; 1 1];
elseif Gauss_point_number==9
    Gauss_coe_ref=[25/81,40/81,25/81,40/81,64/81,40/81,25/81,40/81,25/81];
    Gauss_pos_ref=[-sqrt(0.6),-sqrt(0.6);-sqrt(0.6),0;-sqrt(0.6),sqrt(0.6);0,-sqrt(0.6);0,0;0,sqrt(0.6);sqrt(0.6),-sqrt(0.6);sqrt(0.6),0;sqrt(0.6),sqrt(0.6)];
elseif Gauss_point_number==1
    Gauss_coe_ref=4;
    Gauss_pos_ref=[0,0];
elseif Gauss_point_number==25
    w = [0.236926885 0.478628670 0.568888889 0.478628670 0.236926885];
    w = w'*w;
    v = [0.906179845 0.5384693101 0 -0.5384693101 -0.906179845];
    v = repmat(v,[5,1]);
    v1 = v(:);
    vT = v';
    v2 = vT(:);
    Gauss_coe_ref = w(:);
    Gauss_pos_ref = [v1,v2];
end