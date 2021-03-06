function [] = runPlot(stats, test_names, subs)
% 
% 
% 
% 
% 
% 
% 
%% Inquire the plotter

center = input('Would you like to center the data? ');



%% Run Plot
for ii = 1:length(test_names)
    % Create table for individual test
    plot_table = table(stats(ii).data_table.sid, stats(ii).data_table.hours, stats(ii).data_table.score);
    % Name variables in plot table
    plot_table.Properties.VariableNames = {'sid', 'hours', 'score'};
    % find the number of individual subjects
    s = unique(stats(ii).data_table.sid);
    % Create plot matrix
    plot_matrix = nan(length(plot_table.hours), length(s)); 

    % intialize and fix figure    
    figure; hold;
    % loop over each subject over sessions
    for subj = 1:length(s)
         % find the sessions for each subject
         visit_indx = find(plot_table.sid == s(subj));
         % create empty array for individual subject 
         sub_mat = [];
         % loop over each visit
         for visit = 1:length(visit_indx)
             % assign session values to plot array
             sub_mat(visit, 1) = plot_table.hours(visit_indx(visit));
             sub_mat(visit, 2) = plot_table.score(visit_indx(visit));
         end
         % plot the scores, hours v. score
         plot(sub_mat(:,1), sub_mat(:,2),'-o');
    end

    % format the plot nicely
    ylabel(test_names(ii)); xlabel('Hours'); 
    legend(subs, 'Location', 'eastoutside');
    grid('on')

    % Add line of best fit
    xx = [min(plot_table.hours), max(plot_table.hours)];
    y = polyval(flipud(stats(ii).lme.Coefficients.Estimate),xx);
    plot(xx,y,'--k','linewidth',2);

end