% By Zhang Ting 2023/11/18
% triangle vertice

function [norm_vector,face_norm, face_center,lc,rc] = get_source_mom_lr(sourcemodel)

% 计算面法向量
P = sourcemodel.pos;
T = sourcemodel.tri;
pnum = size(P,1);
vector1 = P(T(:,1),:) - P(T(:,2),:);
vector2 = P(T(:,3),:) - P(T(:,2),:);
face_norm = cross(vector1,vector2) ;
dist_norm = sqrt(sum(face_norm.^2,2));  
face_norm = face_norm./dist_norm;     % unit normal vector
[indxi, ~, s] = find(T);
face_center = (P(T(:,1),:) + P(T(:,2),:) + P(T(:,3),:)) / 3;

% left
ls = sourcemodel.pos(sourcemodel.brainstructure == 1,:);  % 检查
lc = mean(ls);
ldist = dist(face_center,lc');
% right
rs = sourcemodel.pos(sourcemodel.brainstructure == 2,:);  % 检查
rc = mean(rs);
rdist = dist(face_center,rc');
% 确定face_norm方向
fbrainstructure = (ldist > rdist) + 1;     % 1表示左边2表示右边
lrc = zeros(length(fbrainstructure),3);
lrc(fbrainstructure == 1,:) = repmat(lc,sum(fbrainstructure == 1),1);
lrc(fbrainstructure == 2,:) = repmat(rc,sum(fbrainstructure == 2),1);
center_vector = face_center - lrc;
face_norm = sign(sum(face_norm.*center_vector,2)).*face_norm;  % use sign function to assign direction

norm_vector = zeros(pnum,3);
% left-norm
for i = 1:size(ls,1)
    indx1 = find(ismember(P,ls(i,:),"rows"));
    close_norm = face_norm(indxi(s == indx1),:);
    lcv = ls(i,:) - lc;
    tmpln = mean(close_norm) / norm(mean(close_norm));
    norm_vector(indx1,:) = sign(sum(tmpln*lcv')).*tmpln;
    clear index1 close_norm tmpln
end
% right-norm
for i = 1:size(rs,1)
    indx2 = find(ismember(P,rs(i,:),"rows"));
    close_norm = face_norm(indxi(s == indx2),:);
    rcv = rs(i,:) - rc;
    tmpln = mean(close_norm) / norm(mean(close_norm));
    norm_vector(indx2,:) = sign(sum(tmpln*rcv')).*tmpln;
    clear index2 close_norm tmpln
end
% dist_norm = sqrt(sum(norm_vector.^2,2));  
% norm_vector = norm_vector./dist_norm;     % unit normal vector
% norm_vector = zeros(pnum,3);
% for i = 1:pnum
%     close_norm = face_norm(indxi(s == i),:);
%     norm_vector(i,:) = sum(close_norm);
% end
% dist_norm = sqrt(sum(norm_vector.^2,2));  
% norm_vector = norm_vector./dist_norm;     % unit normal vector

%% ***************************************  SUB FUNCTION  ************************************
% function Fnorm_ = compute_Fnorm(Fnorm,Fcenter,lc,rc)
% fnum = size(Fnorm,1);
% Fnorm_ = zeros(fnum,3);
% for i = 1:fnum
%     if min(dist(lc,Fcenter(i,:)')) < min(dist(rc,Fcenter(i,:)'))
%         center_vector = lc(i,:) - center;
%     else
%         center_vector = rc(i,:) - center;
%     end   % 离中心的距离判断属于哪个半球
% 
%     
% end
end
