% By Zhang Ting 2022/10/21

function [cond,slope] = compute_cond_offCenterTriangle(impedance,center,diameter,p,targetpos,direction,r)
% center : center of round
% p : rate of off center
% targetpos: the target position need compute slope 
% direction: [0 1 0]--y axis,[1,0,0]--x axis, or others

compensation = 1+r*(p/0.5);

% 1. transfer coordinate system: make center = [0,0,0]£¬3 point should in the same plane
if cross(direction,targetpos-center) == 0
    P2 = (targetpos-center);
    P1 = diameter*p*direction/2;
else
    x_axis = direction;
    z_axis = cross(direction,targetpos-center);
    y_axis = cross(z_axis,x_axis);
    T = [x_axis/norm(x_axis);y_axis/norm(y_axis);z_axis/norm(z_axis)];
    P2 = (targetpos-center)/T;
    P1 = diameter*p*direction/2/T;
end
y1 = P1(2);  
x1 = P1(1);
y2 = P2(2);
x2 = P2(1);
if abs(x1 - x2) < 0.05
    % elimiate the situation: x1 = x2
    len = sqrt((diameter/2)^2-x2^2);
    slope = 2*impedance/len;   % Ð±ÂÊ
    cond = compensation*slope*(len-abs(y2-y1));
else
    % 2. get the coefficience of straight line: y = ax+b
    a = (y2-y1)/(x2-x1);
    b = -a*x1+y1;
    % 3. applying the straight line to round equation
    c = a^2+1;
    d = 2*a*b;
    e = b^2-(diameter/2)^2;
    % calculate equation root
    delta = d^2-4*c*e;
    if delta>=0
        root = (-d+sqrt(delta)*[1;-1])/(2*c);
    else
        error('Can not get slope, please check input!')
    end

    % 4. select the appropriate root
    dirc1 = [root,a*root+b]-[x1,y1];
    dirc2 = [x2,y2]-[x1,y1];
    s = sum(dirc1.*dirc2,2)./(sqrt(sum(dirc1.^2,2))*sqrt(sum(dirc2.^2)));
    if s(1)*s(2)<0 && abs(s(1)-1)<1e-10
        % ensure the direction is same
        x3 = root(1);
        y3 = a*root(1)+b;
    elseif s(1)*s(2)<0 && abs(s(2)-1)<1e-10
        % ensure the direction is same
        x3 = root(2);
        y3 = a*root(2)+b;
    else
        error('Can not find the correct slope!')
    end
    if norm([x3,y3]-[x1,y1])<diameter               
        slope = 2*impedance/norm([x3,y3]-[x1,y1]);
        cond = compensation*slope*(norm([x3,y3]-[x2,y2]));
    else
        error('compute domain overflow the electrode domain!')
    end
end
end