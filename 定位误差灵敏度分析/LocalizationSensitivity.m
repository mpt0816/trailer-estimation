clc; clear all; close all;

simulautin_num = 20;
localization_error = 0.0 : 0.01 : 0.20;
max_errors = localization_error;
mean_errors = localization_error;

for i = 0 : 20
  if i < 10
    load_file_name = strcat('filter_result00', num2str(i), '.mat');
  else
    load_file_name = strcat('filter_result0', num2str(i), '.mat');
  end
 
  %% load data
  load(load_file_name);

  %% true value of trailer heading
  true_value = filter_result.data(:,1);
  true_value = true_value(10000:end);

  %% filter value of trailer heading
  filter_value = filter_result.data(:,3);
  filter_value = filter_value(10000:end);

  %% calculate max error and mean error
  error = filter_value - true_value;
  error_abs = abs(error);
  max_error = max(error_abs);
  mean_error = mean(error_abs);
  max_errors(i + 1) = max_error;
  mean_errors(i + 1) = mean_error;
end

%% plot
plot(localization_error, max_errors, '-b', 'LineWidth', 0.5);
hold on;
plot(localization_error, mean_errors, '-k', 'LineWidth', 0.5);
title('localization sensitivity');
xlabel('localization distribution amplitude(m)');
ylabel('trailer heading error(rad)');
legend('max error', 'mean error');