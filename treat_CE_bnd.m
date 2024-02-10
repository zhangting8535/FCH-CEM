% Modified by Zhang Ting 2022/11/06

function [A, B, C] = treat_CE_bnd(stiff, elecmodel,cemtype,impedance)

Gauss_point_number = 9;
A = treat_A(stiff, elecmodel, Gauss_point_number,cemtype,impedance);
B = assemble_B(elecmodel, Gauss_point_number, cemtype,impedance);
C = assemble_C(elecmodel, cemtype,impedance);
