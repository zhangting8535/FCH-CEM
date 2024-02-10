% By Zhang Ting 2022/9/21

function [rows,cols,s] = assemble_off_diag(T,value,cond)

% 1. get rows and cols
point_num = size(T,2);
value_indx = get_line_indx(point_num);
tnum = size(T,1);
all_line = zeros(tnum*size(value_indx,1),2);
tmp = sort(T,2,'descend');    % to get the lower triangular matrix
for i = 1:size(value_indx,1)
    all_line((i-1)*tnum+1:i*tnum,:) = tmp(:,value_indx(i,:));
end
all_line = unique(all_line,'rows');
rows = all_line(:,1);
cols = all_line(:,2);

% 2. compute s
disp('start to compute value......')
s = zeros(length(rows),1);

for j = 1:size(value_indx,1)
    try
        tmps = zeros(length(rows),1);
        Tj = T(:,value_indx(j,:));
        Tj = sort(Tj,2,'descend');
        tmps(ismember(all_line,Tj,'rows')) = value(value_indx(j,1),value_indx(j,2))*cond;
        s = s+tmps;
    catch
        error('Can not use indx!')
    end
end

    function indx = get_line_indx(num)
        indx = zeros(num*(num-1)/2,2);
        accum = [1,num-1:-1:1];
        for i1 = 1:num-1
            start_i = sum(accum(1:i1));
            stop_i = sum(accum(2:i1+1));
            indx(start_i:stop_i,:) = [i1*ones(accum(i1+1),1),[i1+1:num]'];
        end
    end

end

