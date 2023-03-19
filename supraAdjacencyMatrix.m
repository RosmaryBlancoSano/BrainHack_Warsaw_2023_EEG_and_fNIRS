%% add path to functions

addpath 'C:\Users\aurim\brainstorm3'
addpath 'C:\Users\aurim\Desktop\brainhack2023\project\script\functions'

%% set parameters

mainFolder = 'C:\Users\aurim\Desktop\brainhack2023\project\script\data';
outputFolder = 'C:\Users\aurim\Desktop\brainhack2023\project\script\output';

% set variables
Fs = 200; % sampling frequency
nsubs = 22;
nrois = 44; % number of region of interest based on Desikan

%% Load connectivity data 

% Get a list of all the subject folders
subjectList = dir(mainFolder);
subjectList = subjectList(~ismember({subjectList.name},{'.','..'}));

% Get 4D matrices (subject, side, 44x44 connectivity) for each EEG band and both fNIRS measures

pli_delta_full_clean = zeros(nsubs,2,nrois,nrois);
sides = [16,32];
for iSubj = 1:length(subjectList)
    for iSide = 1:2
        file_directory = [mainFolder '\' subjectList(iSubj).name '\' int2str(sides(iSide)) '\' 'FC_files' '/' 'FCdelta.mat'];
        file = load(file_directory);
        pli_delta_full_clean(iSubj,iSide,:,:) = file.FC_delta;
    end
end

pli_theta_full_clean = zeros(nsubs,2,nrois,nrois);
sides = [16,32];
for iSubj = 1:length(subjectList)
    for iSide = 1:2
        file_directory = [mainFolder '\' subjectList(iSubj).name '\' int2str(sides(iSide)) '\' 'FC_files' '/' 'FCtheta.mat'];
        file = load(file_directory);
        pli_theta_full_clean(iSubj,iSide,:,:) = file.FC_theta;
    end
end

pli_alpha_full_clean = zeros(nsubs,2,nrois,nrois);
sides = [16,32];
for iSubj = 1:length(subjectList)
    for iSide = 1:2
        file_directory = [mainFolder '\' subjectList(iSubj).name '\' int2str(sides(iSide)) '\' 'FC_files' '/' 'FCalpha.mat'];
        file = load(file_directory);
        pli_alpha_full_clean(iSubj,iSide,:,:) = file.FC_alpha;
    end
end

pli_beta_full_clean = zeros(nsubs,2,nrois,nrois);
sides = [16,32];
for iSubj = 1:length(subjectList)
    for iSide = 1:2
        file_directory = [mainFolder '\' subjectList(iSubj).name '\' int2str(sides(iSide)) '\' 'FC_files' '/' 'FCbeta.mat'];
        file = load(file_directory);
        pli_beta_full_clean(iSubj,iSide,:,:) = file.FC_beta;
    end
end

pli_gamma_full_clean = zeros(nsubs,2,nrois,nrois);
sides = [16,32];
for iSubj = 1:length(subjectList)
    for iSide = 1:2
        file_directory = [mainFolder '\' subjectList(iSubj).name '\' int2str(sides(iSide)) '\' 'FC_files' '/' 'FCgamma.mat'];
        file = load(file_directory);
        pli_gamma_full_clean(iSubj,iSide,:,:) = file.FC_gamma;
    end
end

hbo_full_clean = zeros(nsubs,2,nrois,nrois);
sides = [16,32];
for iSubj = 1:length(subjectList)
    for iSide = 1:2
        file_directory = [mainFolder '\' subjectList(iSubj).name '\' int2str(sides(iSide)) '\' 'FC_files' '/' 'FChbo.mat'];
        file = load(file_directory);
        hbo_full_clean(iSubj,iSide,:,:) = file.FC_hbo;
    end
end

hbr_full_clean = zeros(nsubs,2,nrois,nrois);
sides = [16,32];
for iSubj = 1:length(subjectList)
    for iSide = 1:2
        file_directory = [mainFolder '\' subjectList(iSubj).name '\' int2str(sides(iSide)) '\' 'FC_files' '/' 'FChbr.mat'];
        file = load(file_directory);
        hbr_full_clean(iSubj,iSide,:,:) = file.FC_hbr;
    end
end


%% Normalize data

pli_delta_full_norm = zeros(nsubs,2,nrois,nrois);
pli_theta_full_norm = zeros(nsubs,2,nrois,nrois);
pli_alpha_full_norm = zeros(nsubs,2,nrois,nrois);
pli_beta_full_norm = zeros(nsubs,2,nrois,nrois);
pli_gamma_full_norm = zeros(nsubs,2,nrois,nrois);

hbo_full_norm = zeros(nsubs,2,nrois,nrois);
hbr_full_norm = zeros(nsubs,2,nrois,nrois);

for sub = 1:nsubs
    for side = 1:2
        M = squeeze(pli_delta_full_clean(sub,side,:,:));
        M = weight_conversion(M,'autofix');
        pli_delta_full_norm(sub,side,:,:) = weight_conversion(M,'normalize'); 

        M = squeeze(pli_theta_full_clean(sub,side,:,:));
        M = weight_conversion(M,'autofix');
        pli_theta_full_norm(sub,side,:,:) = weight_conversion(M,'normalize');

        M = squeeze(pli_alpha_full_clean(sub,side,:,:));
        M = weight_conversion(M,'autofix');
        pli_alpha_full_norm(sub,side,:,:) = weight_conversion(M,'normalize');

        M = squeeze(pli_beta_full_clean(sub,side,:,:));
        M = weight_conversion(M,'autofix');
        pli_beta_full_norm(sub,side,:,:) = weight_conversion(M,'normalize');

        M = squeeze(pli_gamma_full_clean(sub,side,:,:));
        M = weight_conversion(M,'autofix');
        pli_gamma_full_norm(sub,side,:,:) = weight_conversion(M,'normalize');
        
        M = squeeze(hbo_full_clean(sub,side,:,:));
        M = weight_conversion(M,'autofix');
        hbo_full_norm(sub,side,:,:) = weight_conversion(M,'normalize');
        
        M = squeeze(hbr_full_clean(sub,side,:,:));
        M = weight_conversion(M,'autofix');
        hbr_full_norm(sub,side,:,:) = weight_conversion(M,'normalize');
    end
end

% save normalized matrices
save([outputFolder '/full_norm.mat'], '*full_norm');

%% MST

% pre-allocate matrices
mst_pli_del = zeros(nsubs,2, nrois, nrois);
mst_pli_the = zeros(nsubs,2, nrois, nrois);
mst_pli_al = zeros(nsubs,2, nrois, nrois);
mst_pli_bet = zeros(nsubs,2, nrois, nrois);
mst_pli_gam = zeros(nsubs,2, nrois, nrois);

mst_hbo = zeros(nsubs,2, nrois, nrois);
mst_hbr = zeros(nsubs,2, nrois, nrois);


% construct mst
for sub = 1:nsubs
    for side = 1:2
        mst_pli_del(sub,side,:,:) = kruskal_algorithm(squeeze(pli_delta_full_norm(sub,side,:,:)));
        mst_pli_the(sub,side,:,:) = kruskal_algorithm(squeeze(pli_theta_full_norm(sub,side,:,:)));
        mst_pli_al(sub,side,:,:) = kruskal_algorithm(squeeze(pli_alpha_full_norm(sub,side,:,:)));
        mst_pli_bet(sub,side,:,:) = kruskal_algorithm(squeeze(pli_beta_full_norm(sub,side,:,:)));
        mst_pli_gam(sub,side,:,:) = kruskal_algorithm(squeeze(pli_gamma_full_norm(sub,side,:,:)));

        mst_hbo(sub,side,:,:) = kruskal_algorithm(squeeze(hbo_full_norm(sub,side,:,:)));
        mst_hbr(sub,side,:,:) = kruskal_algorithm(squeeze(hbr_full_norm(sub,side,:,:)));
    end
end

save([outputFolder, '/norm_mst.mat'],'mst*')

%% Compute supra-adjacency matrix

% eeg only

nlrs = 5;
id = nrois:nrois:nrois*nlrs;

% pre-allocate supra-adjacency matrices
supra_mst_eeg = zeros(nrois*nlrs, nrois*nlrs, 2, nsubs);

% construct mst supra-adjacency matrix
for c = 1:nsubs
    for s = 1:2
    fprintf(1, 'Now constructing supra_mst for sub %s!\n', num2str(c))
    
    supratmp = blkdiag(squeeze(mst_pli_del(c,s,:,:)), squeeze(mst_pli_the(c,s,:,:)), squeeze(mst_pli_al(c,s,:,:)), squeeze(mst_pli_bet(c,s,:,:)), squeeze(mst_pli_gam(c,s,:,:)));
    for i = 1:length(id)
        supratmp(id(i)*size(supratmp,1)+1:size(supratmp,1)+1:end) = 1;
        supratmp(id(i)+1:size(supratmp, 1)+1:1+size(supratmp, 1)*min(size(supratmp, 1)-id(i),size(supratmp, 2))) = 1;
    end
    supra_mst_eeg(:,:,s,c) = supratmp;
    end
end

supra_mst_eeg_left = squeeze(supra_mst_eeg(:,:,1,:));
supra_mst_eeg_right = squeeze(supra_mst_eeg(:,:,2,:));
save([outputFolder, '/supra_mst_eeg_left.mat'],'supra_mst_eeg_left')
save([outputFolder, '/supra_mst_eeg_right.mat'],'supra_mst_eeg_right')

% fNIRS only

nlrs = 2;
id = nrois:nrois:nrois*nlrs;

% pre-allocate supra-adjacency matrices
supra_mst_fnirs = zeros(nrois*nlrs, nrois*nlrs, 2, nsubs);

% construct mst supra-adjacency matrix
for c = 1:nsubs
    for s = 1:2
    fprintf(1, 'Now constructing supra_mst for sub %s!\n', num2str(c))
    
    supratmp = blkdiag(squeeze(mst_hbo(c,s,:,:)), squeeze(mst_hbr(c,s,:,:)));
    for i = 1:length(id)
        supratmp(id(i)*size(supratmp,1)+1:size(supratmp,1)+1:end) = 1;
        supratmp(id(i)+1:size(supratmp, 1)+1:1+size(supratmp, 1)*min(size(supratmp, 1)-id(i),size(supratmp, 2))) = 1;
    end
    supra_mst_fnirs(:,:,s,c) = supratmp;
    end
end

supra_mst_fnirs_left = squeeze(supra_mst_fnirs(:,:,1,:));
supra_mst_fnirs_right = squeeze(supra_mst_fnirs(:,:,2,:));
save([outputFolder, '/supra_mst_fnirs_left.mat'],'supra_mst_fnirs_left')
save([outputFolder, '/supra_mst_fnirs_right.mat'],'supra_mst_fnirs_right')


% full

nlrs = 7;
id = nrois:nrois:nrois*nlrs;

% pre-allocate supra-adjacency matrices
supra_mst_full = zeros(nrois*nlrs, nrois*nlrs, 2, nsubs);

% construct mst supra-adjacency matrix
for c = 1:nsubs
    for s = 1:2
    fprintf(1, 'Now constructing supra_mst for sub %s!\n', num2str(c))
    
    supratmp = blkdiag(squeeze(mst_pli_del(c,s,:,:)), squeeze(mst_pli_the(c,s,:,:)), squeeze(mst_pli_al(c,s,:,:)), squeeze(mst_pli_bet(c,s,:,:)), squeeze(mst_pli_gam(c,s,:,:)), squeeze(mst_hbo(c,s,:,:)), squeeze(mst_hbr(c,s,:,:)));
    for i = 1:length(id)
        supratmp(id(i)*size(supratmp,1)+1:size(supratmp,1)+1:end) = 1;
        supratmp(id(i)+1:size(supratmp, 1)+1:1+size(supratmp, 1)*min(size(supratmp, 1)-id(i),size(supratmp, 2))) = 1;
    end
    supra_mst_full(:,:,s,c) = supratmp;
    end
end

supra_mst_full_left = squeeze(supra_mst_full(:,:,1,:));
supra_mst_full_right = squeeze(supra_mst_full(:,:,2,:));
save([outputFolder, '/supra_mst_full_left.mat'],'supra_mst_full_left')
save([outputFolder, '/supra_mst_full_right.mat'],'supra_mst_full_right')

