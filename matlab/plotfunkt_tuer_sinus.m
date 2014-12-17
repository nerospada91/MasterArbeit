%load('temp.mat');
plota = (fliplr(temp_sinustuernotouch'));
plotb = (fliplr(temp_sinustuer1finger'));
plotc = (fliplr(temp_sinustuer2finger'));
plotd = (fliplr(temp_sinustuerkreis'));
plote = (fliplr(temp_sinustuerkomplett'));

plot(period_freq, plota, '-g',period_freq, plotb, '-k',period_freq, plotc, '-b',period_freq, plotd, '-r', period_freq, plote, '-m')
hleg1 = legend( 'Keine Berührung','Ein Finger', 'Zwei Finger', 'Zwei Finger umschlossen', 'Umschlossen');
xlabel('Frequenz kHz')
ylabel('Spannung Volt')




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