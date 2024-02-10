% By Zhang Ting 2022

function b = assemble_B(elecmodel, Gauss_point_number, cemtype,impedance)
% only for one electrode
% tic
eleshape = 'qaud';
b = zeros(size(elecmodel.P,1),1);
basis_type_test = 201;
der_x_test = 0;
der_y_test = 0;

% treat electrode
Tl  = elecmodel.Te;
Ne = size(Tl,1);
nlb_test= size(Tl ,2);
for n = 1 : Ne
    % pos included in electrode l
    vertices = elecmodel.P(Tl(n,:),:);
    vertices = affine_3D_to_2D(vertices);
    [Gauss_coe_ref,Gauss_pos_ref]=generate_Gauss_ref_quad(Gauss_point_number);
    [Gauss_weights, Gauss_notes] = generate_Gauss_loc_quad(Gauss_coe_ref,Gauss_pos_ref,vertices);
    if strcmp(cemtype, 'sCEM')
        cond = elecmodel.cond_scem(n)/impedance;
    else
        cond = 1/impedance;
    end
    for beta = 1 : nlb_test
        % test function
        int_value = Gauss_int_qaud_test(cond, Gauss_weights, Gauss_notes, vertices, basis_type_test, beta, der_x_test, der_y_test, eleshape);
        b(Tl(n, beta), 1) =  b(Tl(n, beta), 1) +  int_value;
    end

end
% time_end = toc;
% disp(['B has been assembled-----cost time: ',num2str(time_end), 's'])