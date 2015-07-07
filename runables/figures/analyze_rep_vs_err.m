load(['data/', name]);
dir = 'fig/rep_vs_err';

position = [0.1 0.3 .85 .75];
angle = 45;

ssc = 0;
sssc = [];
rssc = [];
for i = 1:length(names)
    if all(names{i}(1:4) == 'SSC ')
        ssc = mean(err(i, :));
    elseif all(names{i}(1:4) == 'SSSC')
        sssc = [sssc; [length(rep{1}{i}), mean(err(i, :))]];
    else
        rssc = [rssc; [length(rep{1}{i}), mean(err(i, :))]];
    end
end
hold on;
plot([0, N], [ssc, ssc]);
plot(sssc(:, 1), sssc(:, 2));
plot(rssc(:, 1), rssc(:, 2));
legend('SSC', 'SSSC', 'RSSC');