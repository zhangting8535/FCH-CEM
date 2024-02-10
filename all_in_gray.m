% By Zhang Ting   2023/11/17

function [index] = all_in_gray(pos, vol)
% 0. prepare data
node = vol.pos;
hex = vol.hex;
tissue = vol.tissue;
tislabel = vol.tissuelabel;
% 1. find source position in head model
[next_tissue,~] = sb_get_next_nd(pos,node,hex,tissue);

% 2. find scalp, skull, and gray
ss_num = [find(ismember(tislabel,'skull')),find(ismember(tislabel,'scalp')),find(ismember(tislabel,'csf'))];

% 3. the index excluding scalp, skull, and gray
 index = ~logical(sum(next_tissue == ss_num(1) | next_tissue == ss_num(2) | next_tissue == ss_num(3),2));

%% ################################ SUB FUNCTION ##############################
function [next_tissue,next_nd] = sb_get_next_nd(pos,node,hex,tissue)
next_nd = zeros(size(pos,1),1);
next_tissue = zeros(size(pos,1), 8);
hex_num = length(tissue);
index_alter = (0:7)*hex_num; 
for i=1:size(pos,1)
    [~, next_nd(i)] = min(sum(bsxfun(@minus,node,pos(i,:)).^2,2));
    next_tissue(i,:) = tissue(find(hex == next_nd(i))-index_alter');
end
end

end