function addLibrary(folder)
% ADDLIBRARY Backwards-compatible wrapper inside inslib/ calling Setup_Paths.

inslibDir = fileparts(mfilename('fullpath'));
if isempty(inslibDir)
    inslibDir = pwd;
end
rootDir = fileparts(inslibDir);

% Ensure root Setup_Paths is executed with legacy paths enabled
if exist(fullfile(rootDir, 'Setup_Paths.m'), 'file') == 2
    addpath(rootDir);
    Setup_Paths(true);
else
    addpath(inslibDir);
end

if nargin >= 1 && ~isempty(folder) && ~strcmp(folder, 'inslib')
    targetDir = fullfile(rootDir, folder);
    if exist(targetDir, 'dir')
        addpath(genpath(targetDir));
    elseif exist(fullfile(inslibDir, folder), 'dir')
        addpath(genpath(fullfile(inslibDir, folder)));
    end
end
end
