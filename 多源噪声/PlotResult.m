clc; clear; close all;
%% load data
load('filter_result.mat');
%% simulation timestamp
timestamp = filter_result.Time;
timestamp = timestamp(10000:end);
%% true value of trailer heading
true_value = filter_result.data(:,1);
true_value = true_value(10000:end);
%% value of trailer heading added noise
noise_value = filter_result.data(:,2);
noise_value = noise_value(10000:end);
%% filter value of trailer heading
filter_value = filter_result.data(:,3);
filter_value = filter_value(10000:end);

figure;
%% plot simulation result
subplot(3, 1, 1);
plot(timestamp, true_value, '-r', 'LineWidth', 0.5);
hold on;
plot(timestamp, noise_value, '-k', 'LineWidth', 0.5);
hold on;
plot(timestamp, filter_value, '-b', 'LineWidth', 0.5);

title('simulation result');
xlabel('time(s)');
ylabel('trailer heading(rad)');
legend('true value', 'noise value', 'filter value');

%% plot error
subplot(3, 1, 2);
error = filter_value - true_value;
error_abs = abs(error);
max_error = max(error_abs);
mean_error = mean(error_abs);
max_error_str = num2str(max_error);
mean_error_str = num2str(mean_error);
text_info = strcat('max error = ', max_error_str, ', mean error = ', mean_error_str, '(all is absolute value)');
plot(timestamp, error, '-r', 'LineWidth', 0.5);
title(text_info);
xlabel('time(s)');
ylabel('error(rad)');
legend('filter value - true value');

%% plot histogram
subplot(3, 1, 3);
h1 = histogram(error, 'Normalization', 'probability');
hold on;
h2 = histogram(noise_value - true_value, 'Normalization', 'probability');
h1.BinWidth = h2.BinWidth;
title('histogram');
xlabel('error');
ylabel('probability');
legend('filter histogram', 'noise histogram');

