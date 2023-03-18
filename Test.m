mainFolder = 'C:\Users\RosmaryBlanco\Documents\brainstorm_db\eeg-nirs-study\FC_export_from_Brainstorm\FC_task';

% Get a list of all the subject folders
subjectList = dir(mainFolder)

for s = 1:length(subjectList)
    if subjectList(s).isdir && ~strcmp(subjectList(s).name, '.') && ~strcmp(subjectList(s).name, '..')
        % Get the name of the subject folder
        subjectFolder = [mainFolder '\' subjectList(s).name '\16\FC_files'];
            
        % Get a list of all the files in the subfolder
        fileList = dir(subjectFolder);
        for r = 1:length(fileList)
            if ~strcmp(subjectList(s).name, '.') && ~strcmp(subjectList(s).name, '..')
                file = [subjectFolder '\' fileList(r).name]
            end
        end
        
        
        subjectFolder = [mainFolder '\' subjectList(s).name '\32\FC_files'];
            
        % Get a list of all the files in the subfolder
        fileList = dir(subjectFolder);
        for r = 1:length(fileList)
            if ~strcmp(subjectList(s).name, '.') && ~strcmp(subjectList(s).name, '..')
                file = [subjectFolder '\' fileList(r).name]
            end
        end
        
    end
end