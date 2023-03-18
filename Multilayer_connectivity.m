
% -----------------------------EEG----------------------------------------
% set variables
Fs = 200; % sampling frequency
subs = dir(filepat);
nsubs = length(subs);
nrois = 44; % number of region of interest based on Desikan
% get 3D array, SUBxROIxROI

% ----------------------------- normalize ---------------------------------

% set variables
nrois = length(pli_delta_full_clean(1,1,:));

mainFolder = 'C:\Users\RosmaryBlanco\Documents\brainstorm_db\eeg-nirs-study\FC_export_from_Brainstorm\FC_task';

% Get a list of all the subject folders
subjectList = dir(mainFolder);

% Loop over each subject folder
for s = 1:length(subjectList)
    if subjectList(s).isdir && ~strcmp(subjectList(s).name, '.') && ~strcmp(subjectList(s).name, '..')
        % Get the name of the subject folder
        subjectFolder = [mainFolder subjectList(s).name '/'];
        
        % Get a list of all the data subfolders in the subject folder
        subfolders = {'16', '32'};
        
        
        
        
        % Loop over each subfolder
        for i = 1:length(subfolders)
            % Get the name of the subfolder
            subfolder = [subjectFolder subfolders{i} '/'];
            
            
            % Get a list of all the files in the subfolder
            fileList = dir([subfolder '*.mat']);
            
        end
    end
end

% EEG
pli_delta_full_norm = zeros(nsubs,nrois,nrois);
pli_theta_full_norm = zeros(nsubs,nrois,nrois);
pli_alpha1_full_norm = zeros(nsubs,nrois,nrois);
pli_alpha2_full_norm = zeros(nsubs,nrois,nrois);
pli_beta_full_norm = zeros(nsubs,nrois,nrois);
pli_gamma_full_norm = zeros(nsubs,nrois,nrois);
for sub = 1:nsubs
    M = squeeze(pli_delta_full_clean(sub,:,:));
    M = weight_conversion(M,'autofix');
    pli_delta_full_norm(sub,:,:) = weight_conversion(M,'normalize'); 
    
    M = squeeze(pli_theta_full_clean(sub,:,:));
    M = weight_conversion(M,'autofix');
    pli_theta_full_norm(sub,:,:) = weight_conversion(M,'normalize');
    
    M = squeeze(pli_alpha1_full_clean(sub,:,:));
    M = weight_conversion(M,'autofix');
    pli_alpha1_full_norm(sub,:,:) = weight_conversion(M,'normalize');
    
    M = squeeze(pli_alpha2_full_clean(sub,:,:));
    M = weight_conversion(M,'autofix');
    pli_alpha2_full_norm(sub,:,:) = weight_conversion(M,'normalize');
    
    M = squeeze(pli_beta_full_clean(sub,:,:));
    M = weight_conversion(M,'autofix');
    pli_beta_full_norm(sub,:,:) = weight_conversion(M,'normalize');
    
    M = squeeze(pli_gamma_full_clean(sub,:,:));
    M = weight_conversion(M,'autofix');
    pli_gamma_full_norm(sub,:,:) = weight_conversion(M,'normalize');
end

% save normalized matrices
save('C:\Users\RosmaryBlanco\Documents\brainstorm_db\eeg-nirs-study\FC_export_from_Brainstorm\FC_task\FC_norm_all_subj,'*full_norm')









