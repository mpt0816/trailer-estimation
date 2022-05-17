function [res] = SteerMeanFilter(u, n)
persistent static_steer_data;
if isempty(static_steer_data)
    static_steer_data = zeros(1, n);
end
for i = 1 : n - 1
    static_steer_data(1, i) = static_steer_data(1, i + 1);
end
static_steer_data(1, end) = u;
res = sum(static_steer_data(:)) / n;
end