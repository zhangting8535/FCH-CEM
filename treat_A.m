% By Zhang Ting 2022/9/9   modified by 2022/11/06
% only for one electrode
% Tl  = get_correct_T(elec_model.P,elec_model.Te);

function A = treat_A(A, elec_model, Gauss_point_number, cemtype,impedance)

Tl = elec_model.Te;
value = assemble_single_element(Tl(1,:),elec_model.P(Tl(1,:),:),Gauss_point_number);
Ne = size(Tl,1);
for n = 1 : Ne
    % pos included in electrode l
    if strcmp(cemtype, 'sCEM')
        cond = elec_model.cond_scem(n)/impedance;  % 计算是设置接触电导为1
    else
        cond = 1/impedance;
    end
    A(Tl(n, :), Tl(n, :)) =  A(Tl(n, :), Tl(n, :)) + cond*value;
end 

%% ********************** SUB-FUNCTION *************************
function value = assemble_single_element(T,vertices,Gauss_point_number)
    eleshape = 'qaud';
    basis_type_trial = 201;
    basis_type_test = 201;
    der_x_trial = 0;
    der_y_trial = 0;
    der_x_test = 0;
    der_y_test = 0;
    nlb_trial = size(T, 2);
    nlb_test= size(T ,2);
    vertices = affine_3D_to_2D(vertices);
    [Gauss_coe_ref,Gauss_pos_ref]=generate_Gauss_ref_quad(Gauss_point_number);
    [Gauss_weights, Gauss_notes] = generate_Gauss_loc_quad(Gauss_coe_ref,Gauss_pos_ref,vertices);
    value = zeros(nlb_trial,nlb_test);
    for  alpha = 1: nlb_trial
    % trial function
        for beta = 1 : nlb_test
            % test function
            int_value = Gauss_int_qaud_trial_test(1, Gauss_weights, Gauss_notes, vertices, basis_type_trial, alpha, der_x_trial,der_y_trial, basis_type_test, beta, der_x_test,der_y_test, eleshape);
            value(alpha,beta) = value(alpha,beta)+int_value;
        end
    end 
end

end
