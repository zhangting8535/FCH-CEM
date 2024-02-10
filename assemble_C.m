% By Zhang Ting 2022

function C = assemble_C(elec_model, cemtype,impedance)

% treat electrode
Tl  = elec_model.Te;
Ne = size(Tl,1);
C = 0;
for n = 1 : Ne
    % pos included in electrode l
    if strcmp(cemtype, 'sCEM')
        cond = elec_model.cond_scem(n)/impedance;
    else
        cond = 1/impedance;
    end
    vertices = elec_model.P(Tl(n,:),:);
    int_value = cond * generate_qaud_area(vertices);
    C = C + int_value;
end
% 
% disp('C has been assembled!')