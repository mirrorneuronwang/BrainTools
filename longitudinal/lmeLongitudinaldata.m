function [lme, lme2, data_table] = lmeLongitudinaldata(sid, hours, test_name, reading_score)
% Calculates linear mixed effects on longitudinal data
% 
% [lme, lme2, data_table] = lmeLongitudinaldata(sid, hours, test_name, reading_score)
% 
% Inputs: 
% sid
% hours
% test_name
% reading_score
% 
% Outputs:
% 
% lme
% lme2
% data_table
% 
% Example:
% 
% data = []; subs = {'...', '...', '...'}; test_name = 'WJ_BRS';
% [sid, hours, reading_score] = prepLongitudinaldata(data, subs, ...
% test_name);
% [lme, lme2, data_table] = lmeLongitudinaldata(sid, hours, test_name, reading_score);

%% Create Variations for Model Testing

hours_sq = hours.^2;

%% Create DataSet
reading_score = cell2mat(reading_score);
data_table = dataset(sid, hours, hours_sq, reading_score);

%% Calculate LME fit
% Make sid a categorical variable
data_table.sid = categorical(data_table.sid);
% Fit the model where we predict reading_score as changing linearly with the number of
% hours of intervention
lme = fitlme(data_table, 'reading_score ~ hours + (1|sid)');
% Fit the model where we predict reading score as changing quadratically with hours of
% intervention
lme2 = fitlme(data_table, 'reading_score ~ hours + hours_sq + (1|sid)');


return


