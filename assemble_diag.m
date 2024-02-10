% By Zhang Ting 2022/9/21

function dia = assemble_diag(T,dia,dia_num,cond)

dia_matrix = zeros(dia_num,size(T,2));
for i = 1:size(T,2)
    dia_matrix(T(:,i),i) = dia(i)*cond;
end
dia  =sum(dia_matrix,2);