% By Zhang Ting 2022/9/9

function int_value = Gauss_int_qaud_test(coe, Gauss_coe, Gauss_pos, vertices, basis_type_test, basis_index_test, der_x_test,der_y_test, eleshape)
int_value = 0;
Gpn = length(Gauss_coe);   
for k = 1 : Gpn
%     fprintf('Gauss note --- %d\n', k); 
    int_value = int_value + Gauss_coe(k) * coe * loc_basis_quad(Gauss_pos(k,:), vertices, basis_type_test, basis_index_test, der_x_test, der_y_test, eleshape) ;
end
end
