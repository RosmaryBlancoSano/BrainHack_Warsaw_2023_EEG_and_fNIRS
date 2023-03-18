
% -----------------------------EEG----------------------------------------
% set variables
Fs = 200; % sampling frequency
subs = dir(filepat);
nsubs = 22;
nrois = 44; % number of region of interest based on Desikan
% get 3D array, SUBxROIxROI
addpath 'D:\SanDiskSecureAccess\BCT\2019_03_03_BCT'
my_folder = 'C:\Users\RosmaryBlanco\Documents\brainstorm_db\eeg-nirs-study\FC_export_from_Brainstorm\FC_task\';
subjectList = dir(my_folder);

subjectList = subjectList(~ismember({subjectList.name}, {'.', '..'}));
sides = [16, 32];
for iSubj = 1: length(subjectList)
    for iSide = 1:2
        cd([my_folder '\' subjectList(iSubj).name '\' int2str(sides(iSide)) '\' 'FC_files']);
        load('FCalpha.mat')
        load('FCbeta.mat')
        load('FCdelta.mat')
        load('FCgamma.mat')
        load('FChbo.mat')
        load('FChbr.mat')
        load('FCtheta.mat')
        
        FC_alpha_allsubj(iSubj,:,:) = FC_alpha(:,:);
        FC_beta_allsubj(iSubj,:,:) = FC_beta(:,:);
        FC_gamma_allsubj(iSubj,:,:) = FC_gamma(:,:);
        FC_theta_allsubj(iSubj,:,:) = FC_theta(:,:);
        FC_delta_allsubj(iSubj,:,:) = FC_delta(:,:);
        FC_hbo_allsubj(iSubj,:,:) = FC_hbo(:,:);
        FC_hbr_allsubj(iSubj,:,:) = FC_hbr(:,:);
        
    end
end

% ----------------------------- normalize -------------------------------- 
for i = 1:length(iSubj)
pli_delta_full_norm(:,:,:) = weight_conversion(FC_delta_allsubj,'normalize');
pli_theta_full_norm(:,:,:) = weight_conversion(FC_theta_allsubj,'normalize');
pli_alpha_full_norm(:,:,:) = weight_conversion(FC_alpha_allsubj,'normalize');
pli_beta_full_norm(:,:,:) = weight_conversion(FC_beta_allsubj,'normalize');
pli_gamma_full_norm(:,:,:) = weight_conversion(FC_gamma_allsubj,'normalize');
pli_hbo_full_norm(:,:,:) = weight_conversion(FC_hbo_allsubj,'normalize');
pli_hbr_full_norm(:,:,:) = weight_conversion(FC_hbr_allsubj,'normalize');
end

%------ PART 2: construct MST ------------------------------------------
% pre-allocate matrices
mst_pli_alpha = zeros(nsub, nrois, nrois);
mst_pli_beta = zeros(nsub, nrois, nrois);
mst_pli_delta = zeros(nsub, nrois, nrois);
mst_pli_theta = zeros(nsub, nrois, nrois);
mst_pli_gamma = zeros(nsub, nrois, nrois);
mst_pli_hbo = zeros(nsub, nrois, nrois);
mst_pli_hbr = zeros(nsub, nrois, nrois);
for j = 1:length(iSubj)
    mst_pli_alpha(j,:,:) = kruskal_algorithm(squeeze(FC_alpha_allsubj(j,:,:)));
    mst_pli_beta(j,:,:) = kruskal_algorithm(squeeze(FC_beta_allsubj(j,:,:)));
    mst_pli_delta(j,:,:) = kruskal_algorithm(squeeze(FC_delta_allsubj(j,:,:)));
    mst_pli_gamma(j,:,:) = kruskal_algorithm(squeeze(FC_gamma_allsubj(j,:,:)));
    mst_pli_theta(j,:,:) = kruskal_algorithm(squeeze(FC_theta_allsubj(j,:,:)));
    mst_pli_hbo(j,:,:) = kruskal_algorithm(squeeze(FC_hbo_allsubj(j,:,:)));
    mst_pli_hbr(j,:,:) = kruskal_algorithm(squeeze(FC_hbr_allsubj(j,:,:)));
end

% ---------------------------- weighted -----------------------------------

% pre-allocate supra-adjacency matrices
supra_weighted_full = zeros(nrois*nlrs, nrois*nlrs, nsubs);
% construct weighted supra-adjacency matrix
for c = 1:nsubs
    fprintf(1, 'Now constructing supra_weighted for sub %s!\n', num2str(c))
    
    supratmp = blkdiag(squeeze(fmri_full_norm(c,:,:)), squeeze(pli_delta_full_norm(c,:,:)), squeeze(pli_theta_full_norm(c,:,:)), squeeze(pli_alpha1_full_norm(c,:,:)), squeeze(pli_alpha2_full_norm(c,:,:)), squeeze(pli_beta_full_norm(c,:,:)), squeeze(pli_gamma_full_norm(c,:,:)), squeeze(dwi_full_norm(c,:,:)));
    for i = 1:length(id)
        supratmp(id(i)*size(supratmp,1)+1:size(supratmp,1)+1:end) = 1;
        supratmp(id(i)+1:size(supratmp, 1)+1:1+size(supratmp, 1)*min(size(supratmp, 1)-id(i),size(supratmp, 2))) = 1;
    end
    supra_weighted_full(:,:,c) = supratmp;
end

% CONSTRUCTING SUPRA-ADJACENCY MATRICES

% set variables
nlrs = 7;
id = nrois:nrois:nrois*nlrs;
nsubs = length(iSubj);

% pre-allocate supra-adjacency matrices
supra_mst_full_EEG = zeros(nrois*nlrs, nrois*nlrs, nsubs);

% construct mst supra-adjacency matrix for EEG
for c = 1:nsubs
    fprintf(1, 'Now constructing supra_mst for sub %s!\n', num2str(c))
    
    supratmp = blkdiag(squeeze(mst_pli_delta(c,:,:)), squeeze(mst_pli_theta(c,:,:)), squeeze(mst_pli_alpha(c,:,:)), squeeze(mst_pli_beta(c,:,:)), squeeze(mst_pli_gamma(c,:,:)));
    for i = 1:length(id)
        supratmp(id(i)*size(supratmp,1)+1:size(supratmp,1)+1:end) = 1;
        supratmp(id(i)+1:size(supratmp, 1)+1:1+size(supratmp, 1)*min(size(supratmp, 1)-id(i),size(supratmp, 2))) = 1;
    end
    supra_mst_full_EEG(:,:,c) = supratmp;
end

% construct mst supra-adjacency matrix for NIRS
% pre-allocate supra-adjacency matrices
supra_mst_full_NIRS = zeros(nrois*nlrs, nrois*nlrs, nsubs);
for c = 1:nsubs
    fprintf(1, 'Now constructing supra_mst for sub %s!\n', num2str(c))
    
    supratmp = blkdiag(squeeze(mst_pli_hbo(c,:,:)), squeeze(mst_pli_hbr(c,:,:)));
    for i = 1:length(id)
        supratmp(id(i)*size(supratmp,1)+1:size(supratmp,1)+1:end) = 1;
        supratmp(id(i)+1:size(supratmp, 1)+1:1+size(supratmp, 1)*min(size(supratmp, 1)-id(i),size(supratmp, 2))) = 1;
    end
    supra_mst_full_NIRS(:,:,c) = supratmp;
end

% pre-allocate supra-adjacency matrices
supra_mst_full = zeros(nrois*nlrs, nrois*nlrs, nsubs);

% construct mst supra-adjacency matrix for both modalities
for c = 1:nsubs
    fprintf(1, 'Now constructing supra_mst for sub %s!\n', num2str(c))
    
    supratmp = blkdiag(squeeze(mst_pli_delta(c,:,:)), squeeze(mst_pli_theta(c,:,:)), squeeze(mst_pli_alpha(c,:,:)), squeeze(mst_pli_beta(c,:,:)), squeeze(mst_pli_gamma(c,:,:)), squeeze(mst_pli_hbo(c,:,:)), squeeze(mst_pli_hbr(c,:,:)));
    for i = 1:length(id)
        supratmp(id(i)*size(supratmp,1)+1:size(supratmp,1)+1:end) = 1;
        supratmp(id(i)+1:size(supratmp, 1)+1:1+size(supratmp, 1)*min(size(supratmp, 1)-id(i),size(supratmp, 2))) = 1;
    end
    supra_mst_full(:,:,c) = supratmp;
end


% PART 3: COMPUTING NETWORK MEASURES)








