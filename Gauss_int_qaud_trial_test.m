% By Zhang Ting 

function int_value = Gauss_int_qaud_trial_test(coe, Gauss_coe, Gauss_pos, vertices, basis_type_trial, basis_index_trial, der_x_trial,der_y_trial, basis_type_test, basis_index_test, der_x_test,der_y_test, eleshape)
int_value = 0;
Gpn = length(Gauss_coe);   % Gaussian integral point
for k = 1 : Gpn
%     fprintf('Gauss note --- %d\n', k);
    int_value = int_value + Gauss_coe(k) * coe * loc_basis_quad(Gauss_pos(k,:), vertices, basis_type_trial, basis_index_trial, der_x_trial, der_y_trial, eleshape) * [loc_basis_quad(Gauss_pos(k,:), vertices, basis_type_test, basis_index_test, der_x_test, der_y_test, eleshape)]' ;
end

end
