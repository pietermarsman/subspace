close all;
figure(10)
boxplot(missrate)
set(gca, 'XTickLabel', {'SSC', 'RSSC all', 'RSSC rep', 'RSSC Mix', 'SSSC', 'HSSC all', 'HSSC rep', 'HSSC Mix'})
ylim([0, 1])
ylabel('Error rate')

figure(11)
boxplot(duration)
ylim([0, max(max(duration))])
set(gca, 'XTickLabel', {'SSC', 'RSSC all', 'RSSC rep', 'RSSC Mix', 'SSSC', 'HSSC all', 'HSSC rep', 'HSSC Mix'})
ylabel('Duration')