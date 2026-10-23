% =========================================================================
% show_results.m
% =========================================================================
% Standalone script/function to print the summary table from a stored
% benchmark_results.mat file without re-running any filters.
%
% Usage:
%   show_results
%   show_results('C:\Users\vinip\Documents\GitHub\IC-Vinicius\benchmark_results.mat')
%   show_results(resultsFile, currentTimestamp)
% =========================================================================

function show_results(resultsFile, currentTimestamp)
    rootDir = fileparts(mfilename('fullpath'));
    if isempty(rootDir)
        rootDir = pwd;
    end
    addpath(rootDir, '-begin');
    if exist('Setup_Paths', 'file')
        Setup_Paths(false, rootDir);
    end

    if nargin < 1 || isempty(resultsFile)
        % Check current directory first, then fall back to the script's directory
        if isfile(fullfile(pwd, 'benchmark_results.mat'))
            resultsFile = fullfile(pwd, 'benchmark_results.mat');
        else
            resultsFile = fullfile(rootDir, 'benchmark_results.mat');
        end
    end

    if nargin < 2
        currentTimestamp = '';
    end

    if ~isfile(resultsFile)
        error('Benchmark results file not found: %s', resultsFile);
    end

    loaded = load(resultsFile);
    if ~isfield(loaded, 'results')
        error('No ''results'' struct found inside: %s', resultsFile);
    end
    results = loaded.results;

    % Compute current reference metadata to evaluate row staleness flags
    run_info.timestamp = currentTimestamp;
    if exist('Default_Filter_Config', 'file')
        run_info.cfg_hash = Config_Hash(Default_Filter_Config());
    else
        run_info.cfg_hash = '?';
    end
    run_info.code_rev = Code_Revision(fileparts(resultsFile));

    % Preserve canonical trajectory order first, then any extra trajectory fields
    canonical_trajs = {'rectangular', 'circular', 'helicoidal'};
    stored_trajs    = fieldnames(results)';
    trajectories    = [canonical_trajs(ismember(canonical_trajs, stored_trajs)), ...
                       setdiff(stored_trajs, canonical_trajs, 'stable')];

    for t = 1:numel(trajectories)
        trajectory = trajectories{t};
        if ~isfield(results, trajectory) || isempty(fieldnames(results.(trajectory)))
            continue;
        end
        line_len   = 140;
        title_text = sprintf(' BENCHMARK RESULTS: %s ', upper(trajectory));
        fprintf('\n\n%s\n', pad(title_text, line_len, 'both', '='));
        fprintf('%-1s %-12s | %-10s | %-10s | %-10s | %-10s | %-7s | %-10s | %-4s | %-8s | %-8s | %-19s\n', ...
            '', 'Filter', 'Tot RMSE', 'Pos(m) RMSE', 'Vel(m/s) RMSE', 'Att(deg) RMSE', 'Time(s)', 'Step(us)', ...
            'Mode', 'Rev', 'Cfg', 'Run at');
        fprintf('%s\n', repmat('-', 1, line_len));

        fields = fieldnames(results.(trajectory));
        for i = 1:numel(fields)
            fName = fields{i};
            res = results.(trajectory).(fName);
            if isfield(res, 'run_info')
                ri = res.run_info;
            else
                ri = struct('timestamp', '?', 'mode', '?', 'cfg_hash', '?', 'code_rev', '?');
            end
            marker = Stale_Marker(res, run_info);
            fprintf('%-1s %-12s | %10.4f | %11.4f | %13.4f | %13.4f | %7.3f | %8.2f | %-4s | %-8s | %-8s | %-19s\n', ...
                marker, fName, res.rmse_total, res.pos_rmse_3d, res.vel_rmse_3d, res.att_rmse_3d, ...
                res.execTime, res.perStepTime * 1e6, ri.mode, ri.code_rev, ri.cfg_hash, ri.timestamp);
        end
        fprintf('%s\n', repmat('=', 1, line_len));
        fprintf(['Row flags: '' '' this run | ''~'' earlier run, same code and config | ' ...
                 '''*'' different code/config or uncommitted code | ''?'' untagged (older format)\n']);
    end
end

function marker = Stale_Marker(res, run_info)
% STALE_MARKER One-character flag printed in front of each summary-table row.
%   res      - stored result entry; res.run_info is missing for entries saved before tagging
%   run_info - metadata of the current invocation (timestamp, mode, cfg_hash, code_rev)
%   ' ' ran in this invocation
%   '~' earlier run with the same code revision and filter configuration
%   '*' different code revision or configuration, or code with uncommitted changes ('+')
%   '?' saved before results were tagged (no run_info)
if ~isfield(res, 'run_info')
    marker = '?';
elseif ~isempty(run_info.timestamp) && strcmp(res.run_info.timestamp, run_info.timestamp)
    marker = ' ';
elseif ~strcmp(res.run_info.cfg_hash, run_info.cfg_hash) ...
        || ~strcmp(res.run_info.code_rev, run_info.code_rev) ...
        || endsWith(res.run_info.code_rev, '+')
    marker = '*';
else
    marker = '~';
end
end

function h = Config_Hash(cfg)
% CONFIG_HASH Short MD5 fingerprint (8 hex chars) of the filter configuration struct.
bytes = getByteStreamFromArray(cfg);
md = java.security.MessageDigest.getInstance('MD5');
digest = typecast(md.digest(bytes), 'uint8');
h = lower(reshape(dec2hex(digest(1:4))', 1, []));
end

function rev = Code_Revision(rootDir)
% CODE_REVISION Short git commit of the repository, with '+' if tracked files have local changes.
[st, out] = system(sprintf('git -C "%s" rev-parse --short HEAD', rootDir));
if st ~= 0
    rev = 'n/a';
    return;
end
rev = strtrim(out);
[st, out] = system(sprintf('git -C "%s" status --porcelain --untracked-files=no', rootDir));
if st == 0 && ~isempty(strtrim(out))
    rev = [rev '+'];
end
end
