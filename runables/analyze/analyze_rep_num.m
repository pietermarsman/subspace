clean

name = 'exp_hr_rep_7361617303.mat';
load(['data/', name]);
dir = 'fig';
savename = [dir, '/num_rep'];
mkdir(dir)

position = [0.1 0.3 .85 .75];
angle = 45;

ssc = 0;
sssc_temp = [];
rssc_temp = [];
hssc_temp = [];
for j = 1:size(rep, 2)
    for i = 1:length(names)
        if strcmp(names{i}(1:3), 'SSC')
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
% [hssc_values, hssc_means, hssc_std] = average_values(hssc_temp);

hold on;
plot([0, N], [ssc, ssc]);
errorbar(sssc_values, sssc_means, sssc_std);
errorbar(rssc_values, rssc_means, rssc_std);
legend('SSC', 'SSSC', 'RSSC');
title(sprintf('N=%d, D=%d', N, D))

beautyplot('#Representatives', 'Error rate', '', false)
ylim([0, 1])
savefig(savename)
export_fig(savename, '-pdf', '-transparent')


