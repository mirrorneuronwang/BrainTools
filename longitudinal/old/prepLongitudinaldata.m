function [sid, long_var, score, test_name] = prepLongitudinaldata(data, subs, test_name, time_course, usesessions)
% Function: Prepares data for lmeLongitudinaldata and plotLongitudinaldata
% Inputs: 
% data
% test_name
% subs
% 
% Outputs:
% sid
% hours
% reading_score
% 
% Example:
% data = []; subs = {'...', '...', '...'}; test_name = 'WJ_BRS'; 
% [sid, time, score, test_name] = prepLongitudinaldata(data, subs, test_name, time_course);

%% Argument Checking
if ~exist('data', 'var') || isempty(data)
    [~, ~, data] = xlsread('~/Desktop/NLR_Scores.xlsx');
    %[~, ~, data] = xlsread('C:\Users\Patrick\Desktop/NLR_Scores.xlsx');
end

if ~exist('subs', 'var') || isempty(subs)
   error('Please enter the subjects you would like to use');  
   return
end

if ~exist('test_name', 'var') || isempty(test_name)
   error('Please enter the reading test of interest');
   return
end


%% Select group of Subjects

% gather column headings
data_ref = data(1,:);
% add '\' preceding each "_" for nicer looking titles/formatting
data_ref = strrep(data_ref, '_', '\_');
% remove data headers from data
data = data(2:end,:);
% find all rows for subjects of interest
data_indx_tmp = [];
data_indx     = [];
for subj = 1:numel(subs)
    data_indx_tmp = find(strcmp(data(:, strcmp(data_ref, 'Subject')), subs(subj)));
    data_indx = vertcat(data_indx, data_indx_tmp);
end
% create refined data array for data of interest
% initialize empty arrays
sid = []; sessions = []; days = []; hours = [];

% vertcat each reading test variable
for subj = 1:numel(data_indx)
    sid        = vertcat(sid, data(data_indx(subj), strcmp(data_ref, 'Subject')));
    sessions    = vertcat(sessions, data(data_indx(subj), strcmp(data_ref, 'LMB\_session')));
    days       = vertcat(days, data(data_indx(subj), strcmp(data_ref, 'Time')));
    hours      = vertcat(hours, data(data_indx(subj), strcmp(data_ref, 'Hours')));   
end

% Convert cell arrays to variables suitable for use with dataset()
hours       = cell2mat(hours);

%% Time Course
% Variable Selection
if time_course == 1
    long_var = hours;
elseif time_course == 2
    long_var = days;
    long_var = cell2mat(long_var);
elseif time_course == 3
    long_var = sessions;
    long_var = cell2mat(long_var);
end

%% Gather Reading Score of Interest
% intialize variable
score = []; 

% vertcat the data into a cell matrix
for subj = 1:numel(data_indx)
score = vertcat(score, data(data_indx(subj), strcmp(data_ref, test_name)));
end
% Convert reading score to matlab variable
score = cell2mat(score);

%% Concentrate on sessions of interest, if applicable
if time_course == 3
    usesessions = [0, 1, 2];
    indx = ismember(long_var, usesessions);
    % remove rows that correspond to the ones we don't want to analyze
    sid = sid(indx); long_var = long_var(indx); score = score(indx);
end

return


