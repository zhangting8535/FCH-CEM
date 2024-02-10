% compute the lead field matrix of point electrode model
% see: "Flexible-center Hat Complete Electrode Model for EEG Forward Problem"

% 0. prepare
headmodel = importdata('*headmodelpath');
elecmodel = importdata('*elecmodelpath');
sourcemodel = importdata('*sourcemodelpath');
% 2. check
visualization_head_source(meshRes,headmodel,sourcemodel);   % check 1£ºCoordinate Match
if size(sourcemodel.Gx,1) == size(headmodel.pos,1)
    disp(['Gx and header model dimensionality matching with dimensions of £º',num2str(size(sourcemodel.Gx,1)),' * ',num2str(size(sourcemodel.Gx,2))])
else
    error('No Gx or dimension mismatch, please check£¡£¡!')
end   % check 2£ºdimension match
if ~isfield(sourcemodel,'Gx')

    if sum(all_in_gray(sourcemodel.pos(sourcemodel.index,:), headmodel)) == sum(sourcemodel.index)
        disp('Source model coordinates are all within the gray matter')
    else
        error('Error sources£¬please check£¡£¡!')
    end     % check3£ºsourec in gray matter---take a long time
end

% 3. leadfield         
[L_pem,transfer ]= compute_leadfield_pem(headmodel,elecmodel,sourcemodel);
