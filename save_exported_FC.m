
% Specify the folder where the subject folders are located
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
            
            % Create a new folder to save the FC files for this subject and subfolder
            saveFolder = [subfolder 'FC_files/'];
            if ~exist(saveFolder, 'dir')
                mkdir(saveFolder);
            end
            
            % Loop over each file and save it if it contains the string "FC" in its filename
            for j = 1:length(fileList)
                filename = fileList(j).name;
                if contains(filename, 'FC')
                    % Load the file
                    data = load([subfolder filename]);

                    % Save the file in the new folder with the same filename
                    save([saveFolder filename], '-struct', 'data');
                    % fprintf('Saved %s\n', [saveFolder filename]);
                end
            end
        end
    end
end

my_folder = 'C:\Users\RosmaryBlanco\Documents\brainstorm_db\eeg-nirs-study\FC_export_from_Brainstorm\FC_task\';
subjectList = dir(my_folder);

subjectList = subjectList(~ismember({subjectList.name}, {'.', '..'}));
sides = [16, 32];
for iSubj = 1: length(subjectList)
    for iSide = 1:2
        cd([my_folder '\' subjectList(iSubj).name '\' int2str(sides(iSide))]);
        load('FCalpha.mat')
        load('FCbeta.mat')
        load('FCdelta.mat')
        load('FCgamma.mat')
        load('FChbo.mat')
        load('FChbr.mat')
        load('FCtheta.mat')
 
        FC_alpha = bst_memory('GetConnectMatrix', FC3);
        FC_beta = bst_memory('GetConnectMatrix', FC4);
        FC_delta = bst_memory('GetConnectMatrix', FC6);
        FC_gamma = bst_memory('GetConnectMatrix', FC5);
        FC_hbo = bst_memory('GetConnectMatrix', FC1);
        FC_hbr = bst_memory('GetConnectMatrix', FC2);
        FC_theta = bst_memory('GetConnectMatrix', FC7);

        cd([my_folder '\' subjectList(iSubj).name '\' int2str(sides(iSide)) '\' 'FC_files']);

        save('FCalpha.mat', 'FC_alpha')  
        save('FCbeta.mat', 'FC_beta')           
        save('FCdelta.mat', 'FC_delta')           
        save('FCgamma.mat', 'FC_gamma')           
        save('FChbo.mat', 'FC_hbo')           
        save('FChbr.mat', 'FC_hbr')           
        save('FCtheta.mat', 'FC_theta')
        
    end
    
end

