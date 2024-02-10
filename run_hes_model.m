% Referring to the tutorials of the fieldtrip: https://www.fieldtriptoolbox.org/

clear;
clc;
close all;
warning off
cd mrifilepath   
ft_defaults
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% head model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. read mri
subjectname = 'S';
MR=ft_read_mri('****.dcm');   %DICOM

% 2. reslice
cfg = [];
cfg.dim = MR.dim;
cfg.resolution = 1;          
cfg.dim = [256 256 256];         %256*256*256
mri_rlc1 = ft_volumereslice(cfg,MR);    

% 3. transform to acpc
cfg = [];
cfg.method = 'spm';
cfg.coordsys = 'acpc';
cfg.datatype = 'double';
mri_acpc = ft_volumerealign(cfg, mri_rlc1,target_mri);    %  acpc
transform_vox2acpc = mri_acpc.transform;
save(sprintf('%s_transform_vox2acpc',subjectname), 'transform_vox2acpc');    % save transform

% 4. write acpc
cfg = [];
cfg.filename = sprintf('%s.mgz',subjectname);
cfg.filetype = 'mgz';
cfg.datatype = 'double';
cfg.parameter = 'anatomy';
ft_volumewrite(cfg, mri_acpc);     % .mgz for freesurfer

% 4. segment
cfg = [];
cfg.output = {'gray','white','csf','skull','scalp'};   % segmentation
segmentedmri = ft_volumesegment(cfg,mri_acpc); 

% 5.prepare mesh          
cfg = [];
cfg.method = 'hexahedral';    % mesh element
mesh = ft_prepare_mesh(cfg,segmentedmri);

% 6. headmodel
cfg = [];
cfg.method = 'simbio';    % utilizing simbio toolkit
cfg.conductivity = [0.33 0.14 1.79 0.01 0.43];   % setting conductivity
headmodel = ft_prepare_headmodel(cfg,mesh);
save Yan_headmodel headmodel

% 7. align the electrode
elec = ft_read_sens('*\template\electrode\standard_alphabetic.elc');  % Electrode template path
cfg = [];
cfg.method = 'interactive';
cfg.elec = elec;
cfg.headshape = mesh;
elec_aligned = ft_electroderealign(cfg);    % align to head model

%% %%%%%%%%%%%%%%%%%%%%%%%% after Fresurfer %%%%%%%%%%%%%%%%%%%%%%%%
% Constructing a source model by using Freesurfer, see the Fieldtrip tutorial (https://www.fieldtriptoolbox.org/tutorial/sourcemodel/) 
% and Freesurfer tutorial (https://surfer.nmr.mgh.harvard.edu/) for details
% Here are the steps to follow after Freesurfer

cd *\workbench
filename = fullfile([subjectname,'.L.midthickness.8k_fs_LR.surf.gii']);
source = ft_read_headshape({filename, strrep(filename, '.L.', '.R.')});   %加载Freesurfer处理后的源模型
source.inside = source.atlasroi>0;
source.norm = get_source_mom_lr(source);
source = rmfield(source, 'atlasroi');
%% %%%%%%%%%%%%%%%%%%%%%%%%  Drawing for checking  %%%%%%%%%%%%%%%%%%%%%%%%
% Requires fieldtrip installation
figure
ft_plot_mesh(mesh,'facealpha',.2)
hold on
ft_plot_mesh(source)