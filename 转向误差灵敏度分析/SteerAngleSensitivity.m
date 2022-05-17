clc; clear all; close all;

simulautin_num = 20;
steer_angle_error = 0.0 : 0.005 : 0.1;
max_errors = steer_angle_error;
mean_errors = steer_angle_error;

for i = 0 : 20
  if i == 0
    load_file_name = 'filter_result0000.mat';
  elseif i < 2
    load_file_name = strcat('filter_result000', num2str(i * 5), '.mat');
  elseif i < 20
    load_file_name = strcat('filter_result00', num2str(i * 5), '.mat');
  else
    load_file_name = strcat('filter_result0100.mat');
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
plot(steer_angle_error, max_errors, '-b', 'LineWidth', 0.5);
hold on;
plot(steer_angle_error, mean_errors, '-k', 'LineWidth', 0.5);
title('steer angle sensitivity');
xlabel('steer angle distribution amplitude(rad)');
ylabel('trailer heading error(rad)');
legend('max error', 'mean error');