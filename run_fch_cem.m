% get flexible-center hat-shaped distribution of electrode contact conductance
% see: "Flexible-center Hat Complete Electrode Model for EEG Forward Problem"

elecnum = 64;
CemPath = "the path for electrode with different diameter";
eleclabel = importdata('electrode label path');
ftpath = 'D:\0--Experiments\Codes\Function\fieldtrip-20220321';
elecfilepath = fullfile(ftpath, '\template\electrode\standard_alphabetic.elc');
needcheck = ~isauto;   % don't need check
headmodel = importdata('*headmodelpath');
elecmodel = importdata('*elecmodelpath');
sourcemodel = importdata('*sourcemodelpath');
diameter = [0 5;0,10;0 20];
r = [0.07 0.04 0.02];  % compensation coefficient
impedance_error = zeros(elecnum,size(diameter,1));
lambda = [0,0.7];
Time = zeros(length(lambda),1);
for i = 2:length(lambda)
    tic
    for j = 3:size(diameter,1)
        for k = 1:elecnum 
                disp(['compute ',num2str(k),' / ', num2str(elecnum), ' electrode']) 
                cfg_temp = [];
                cfg_temp.auto = isauto;
                cfg_temp.shape = 'round';
                cfg_temp.lambda = lambda(i);
                cfg_temp.size = diameter(j,:);
                cfg_temp.loadtype = eleclabel{k};
                cfg_temp.bndpath = bndpath;   % for loading boundary of head model
                cfg_temp.r = r(j);
                [~,error] = assemble_elecmodel(headmodel, elecmodel,cfg_temp);
                impedance_error(k,j) = error;
        end
    end
end