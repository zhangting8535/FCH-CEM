
function boundary = search_boundary_v3(headmodel)

%% start
% 1. find face
square1 = headmodel.hex(:, [1 2 3 4]);
square2 = headmodel.hex(:, [5 6 7 8]);
square3 = headmodel.hex(:, [1 2 6 5]);
square4 = headmodel.hex(:, [2 3 7 6]);
square5 = headmodel.hex(:, [3 4 8 7]);
square6 = headmodel.hex(:, [4 1 5 8]);
edge = cat(1, square1, square2, square3, square4, square5, square6);  
% 2. arrange in column order: 
sedge = sort(edge,2);

% 3. 
indx = findsingleoccurringrows(sedge);
Tb = edge(indx, :);

% 4. 
pindx = unique(Tb(:));
Pb = [pindx,headmodel.pos(pindx,:)];
boundary.Pb = Pb;
boundary.Tb = Tb;
boundary.P = headmodel.pos;
%%
function indx = findsingleoccurringrows(X)
    % 
    [X, indx] = sortrows(X);
    sel = any(diff([X(1,:)-1;X],1),2) & any(diff([X;X(end,:)+1],1),2);
    indx = indx(sel);
end
end
