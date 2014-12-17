%load('temp.mat');
plota = (fliplr(temp_sinustuernotouch'));
plotb = (fliplr(temp_sinustuer1finger'));
plotc = (fliplr(temp_sinustuer2finger'));
plotd = (fliplr(temp_sinustuerkreis'));
plote = (fliplr(temp_sinustuerkomplett'));

plot(period_freq, plotb, '-g',period_freq, plotd, '-k',period_freq, plotc, '-b',period_freq, plotd, '-r', period_freq, plota, '-m', period_freq, plotc, '-c')
hleg1 = legend( 'Mann 1','Mann 2', 'Mann 3', 'Mann 4', 'Frau 1', 'Frau 2');
xlabel('Frequenz kHz')
ylabel('Spannung Volt')
ylim([0 1.5]);



% plotx = ((VarName2));
% 
% plot(plotx, '--rs',...
%     'LineWidth',1,...
%     'MarkerSize',3,...
%     'MarkerEdgeColor','k',...
%     'MarkerFaceColor','g')
% 
% ylabel('Frequenz kHz')
% xlabel('Frequenzschritt')