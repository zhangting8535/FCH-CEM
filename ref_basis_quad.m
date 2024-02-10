% By Zhang Ting 2022/9/9
%{
compute the volume of a qaud element
                       v1------v4
                       /        /
                    v2------v3
%}
%{
compute the coefficient
N1 = [-1 1; -1 -1; 1 -1; 1 1];
N1 = N1'
N = [N1;N1(1,:).*N1(2,:);ones(1,size(N1,2))];
E = eye(size(N1,2));
coe = inv(N)*E;
%}

function result = ref_basis_quad(xh,yh, basis_type, basis_index, der_x, der_y)
% 201: 2D linear
% 202: 2D quadratic
coe = [ -0.2500    0.2500   -0.2500    0.2500
   -0.2500   -0.2500    0.2500    0.2500
    0.2500   -0.2500   -0.2500    0.2500
    0.2500    0.2500    0.2500    0.2500];

if basis_type == 201
    % only 201
    
     if der_x == 0 && der_y == 0
         vec = [xh;yh;xh*yh;1];
         if basis_index == 1
             result = coe(1,:)*vec;
         elseif basis_index ==2
             result = coe(2,:)*vec;
         elseif basis_index == 3
             result = coe(3,:)*vec;
         elseif basis_index == 4 
             result = coe(4,:)*vec;
         else
             warning('wrong input for basis index!')
         end
         
     elseif der_x == 1 && der_y == 0
         vec = [1;0;yh;0];
         if basis_index == 1
             result = coe(1,:)*vec;
         elseif basis_index ==2
             result = coe(2,:)*vec;
         elseif basis_index == 3
             result = coe(3,:)*vec;
         elseif basis_index == 4 
             result = coe(4,:)*vec;
         else
             warning('wrong input for basis index!')
         end
         
     elseif der_x == 0 && der_y == 1
         
         vec = [0;1;xh;0];
         if basis_index == 1
             result = coe(1,:)*vec;
         elseif basis_index ==2
             result = coe(2,:)*vec;
         elseif basis_index == 3
             result = coe(3,:)*vec;
         elseif basis_index == 4 
             result = coe(4,:)*vec;
         else
             warning('wrong input for basis index!')
         end
         
     elseif der_x ==1 && der_y ==1
         
         vec = [0;0;1;0];
         if basis_index == 1
             result = coe(1,:)*vec;
         elseif basis_index ==2
             result = coe(2,:)*vec;
         elseif basis_index == 3
             result = coe(3,:)*vec;
         elseif basis_index == 4 
             result = coe(4,:)*vec;
         else
             warning('wrong input for basis index!')
         end
         
     elseif (der_x>=2 &&rem(der_x, 1)==0) || (der_y>=2 &&rem(der_y, 1)==0)
         result = 0;
     else
         warning('wrong input for basis index!')
     end
     
elseif basis_type == 202
   
else
    warning('wrong input for basis type!')
end
end