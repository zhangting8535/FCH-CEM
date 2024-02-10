% By Zhang Ting 
% Decompose a quadrilateral into two triangles

function area = generate_qaud_area(vertices)
vertices = [vertices(1:3,:);vertices([1,3,4],:)];  % 6*3
% area
area = 0;
for i = 1:2
    tri = vertices(3*(i-1)+1:3*(i-1)+3,:);
    % the Helen formula
    A = sqrt(sum((tri(1,:) - tri(2,:)).^2));
    B = sqrt(sum((tri(1,:) - tri(3,:)).^2));
    C = sqrt(sum((tri(3,:) - tri(2,:)).^2));
    P = (A + B + C) / 2;
    area = area + sqrt(P*(P-A)*(P-B)*(P-C));
end