function [res] = DsMeanFilter(u, n)
persistent static_ds_data;
if isempty(static_ds_data)
    static_ds_data = zeros(1, n);
end
for i = 1 : n - 1
    static_ds_data(1, i) = static_ds_data(1, i + 1);
end
static_ds_data(1, end) = u;
max_value = max(static_ds_data);
% min_value = min(static_ds_data);
res = (sum(static_ds_data(:))) / (n);
end