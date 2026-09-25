function needsRebuild = Check_MEX_Dependencies(filterName, forceRebuild)
% CHECK_MEX_DEPENDENCIES Scans all source file timestamps in the library
% to determine if the compiled MEX binary is stale.
% Prevents running stale MEX binaries when underlying core/filter files change.
%
% Inputs:
%   filterName   - Filter name string (e.g. 'UKF_Lie', 'EKF_Lie', 'SPUKF_Lie')
%   forceRebuild - Boolean flag to force recompilation (default: false)
%
% Output:
%   needsRebuild - Boolean (true if MEX missing or stale)

if nargin < 2 || isempty(forceRebuild)
    forceRebuild = false;
end

if forceRebuild
    needsRebuild = true;
    return;
end

rootDir = fileparts(fileparts(mfilename('fullpath')));
if isempty(rootDir)
    rootDir = pwd;
end

mexFileName = ['run_' filterName '_mex.' mexext];
mexFile = fullfile(rootDir, 'build', 'mex', mexFileName);
if ~isfile(mexFile)
    mexFile = which(mexFileName);
end

if isempty(mexFile) || ~isfile(mexFile)
    needsRebuild = true;
    return;
end

mexInfo = dir(mexFile);
if isempty(mexInfo)
    needsRebuild = true;
    return;
end
mexDate = mexInfo.datenum;

% Dependent directories to scan recursively for changes
depDirs = { ...
    fullfile(rootDir, 'runners'), ...
    fullfile(rootDir, 'build'), ...
    fullfile(rootDir, 'core'), ...
    fullfile(rootDir, 'filters'), ...
    fullfile(rootDir, 'config'), ...
    fullfile(rootDir, 'geodesy'), ...
    fullfile(rootDir, 'metrics') ...
};

needsRebuild = false;

for d = 1:numel(depDirs)
    currDir = depDirs{d};
    if isfolder(currDir)
        mFiles = dir(fullfile(currDir, '**', '*.m'));
        for f = 1:numel(mFiles)
            if mFiles(f).datenum > mexDate
                fprintf('Source %s modified since MEX build. Triggering recompile...\n', mFiles(f).name);
                needsRebuild = true;
                return;
            end
        end
    end
end

end