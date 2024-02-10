% compute the lead field matrix of complete electrode model and two flexible-center hat complete electrode model
% see: "Flexible-center Hat Complete Electrode Model for EEG Forward Problem"

% 0. setting
basic = 1;
impedance = basic*[1e-1,1,10,100,1000,10000,100000];
impe = impedance([1,7]);
eleclabel = importdata('*eleclabelpath');
targetlabel = eleclabel;
diameter = [0 0 0;5 10 20];
lambda = [0, 0, 0.7];
%% 0. prepare data path
% 1. load modelp
headmodel = importdata('*headmodelpath');
elecmodel = importdata('*elecmodelpath');
sourcemodel = importdata('*sourcemodelpath');
% 2. compute
for i = 2:size(diameter,2)
    for j = 1:length(impedance)
        for k = 1:length(lambda)
            if k == 1
                cemtype = 'CEM';
            else
                cemtype = 'sCEM';
            end 
            cfg = [];
            cfg.loadtype = targetlabel;
            cfg.shape = {'round'};
            cfg.lambda = lambda(k);
            cfg.size = diameter(:,i);
            cfg.impedance = impe(j);
            cfg.datapath = DataPath;
            cfg.cempath = CemPath;
            cfg.cemtype = cemtype;
            cfg.basic = basic;
            [L_cem,time_cont] = compute_leadfield_cem(headmodel, sourcemodel, cfg);
        end
    end
end