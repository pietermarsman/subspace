function analyze_rep_vs_err()
clear all;

name = 'num_representatives81472.mat';
load(['data/', name]);
dir = 'fig/rep_vs_err';

position = [0.1 0.3 .85 .75];
angle = 45;

ssc = 0;
sssc_temp = [];
rssc_temp = [];
hssc_temp = [];
for j = 1:size(rep, 2)
    for i = 1:length(names)
        if all(names{i}(1:4) == 'SSC ')
            ssc = mean(err(i, :));
        elseif all(names{i}(1:4) == 'SSSC')
            sssc_temp = [sssc_temp; [length(rep{j}{i}), mean(err(i, j))]];
        elseif all(names{i}(1:4) == 'HSSC')
            hssc_temp = [hssc_temp; [length(rep{j}{i}), mean(err(i, j))]];
        elseif all(names{i}(1:4) == 'RSSC')
            rssc_temp = [rssc_temp; [length(rep{j}{i}), mean(err(i, j))]];
        else
            warning(sprintf('Name not recognized: %s', names{i}));
        end
    end
end
[sssc_values, sssc_means, sssc_std] = average_values(sssc_temp);
[rssc_values, rssc_means, rssc_std] = average_values(rssc_temp);
    
hold on;
plot([0, N], [ssc, ssc]);
errorbar(sssc_values, sssc_means, sssc_std);
errorbar(rssc_values, rssc_means, rssc_std);
legend('SSC', 'SSSC', 'RSSC');

beautyplot('#Representatives', 'Error rate', '', false)


end 

function [values, avg, st] = average_values(values)

new_values = [];
for value = unique(values(:, 1))'
    new_values = [new_values; [value, ...
        mean(values(values(:, 1) == value, 2)), ...
        std(values(values(:, 1) == value, 2))]];
end

values = new_values(:, 1);
avg = new_values(:, 2);
st = new_values(:, 3);

end