% Referring to the fieldtrip-simbio toolkit

function lf = assemble_lf_with_source(vol,pos, ~)

% vol = headmodel
% pos = sourcemodel.pos(sourcemodel.inside,:)
time = datestr(now,13);
disp(['Start compute leadfield ---- time: ', time])
tic
try   
    lf = zeros(3*size(pos,1),size(vol.transfer,1));
    dir = diag([1,1,1]);
%     parlen = fix(size(pos,1)/corenum);
%     for j = 1:corenum
%         % parpool compute
%         temp = zeros(3*size(pos,1),size(vol.transfer,1));
%         for i=parlen*(j-1)+1:parlen*j
%             locpos = repmat(pos(i,:),3,1);
%             rhs = sb_rhs_venant(locpos,dir,vol);
%             temp((3*(i-1)+1):(3*(i-1)+3),:) = (vol.transfer * rhs)';
%         end
%         lf = lf+temp;
%     end
%     
%     for r = corenum*parlen:size(pos,1)
%         % remain circle
%         locpos = repmat(pos(r,:),3,1);
%         rhs = sb_rhs_venant(locpos,dir,vol);
%         lf((3*(r-1)+1):(3*(r-1)+3),:) = (vol.transfer * rhs)';
%     end
%     tic
    for i=1:size(pos,1)
        locpos = repmat(pos(i,:),3,1);
        rhs = sb_rhs_venant(locpos,dir,vol);
        lf((3*(i-1)+1):(3*(i-1)+3),:) = (vol.transfer * rhs)';
%         time = toc;
%         disp(['Compute leadfield:  [ ',num2str(i),' / ',num2str(size(pos,1)),' ]',' source----cost time: ',num2str(time/60),' min']);
    end
    
    lf = lf';
catch
  ft_warning('an error occurred while running simbio');
  rethrow(lasterror)
end
lf = mat2cell(lf, size(lf,1), repmat(3,1,size(lf,2)/3));
time_end = toc;
disp(['Leadfield has been assembled-----cost time: ',num2str(time_end), 's'])