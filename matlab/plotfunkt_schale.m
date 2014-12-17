%load('temp.mat');
plota = (fliplr(temp_schalenotouch'));
plotb = (fliplr(temp_schale1finger'));
plotc = (fliplr(temp_schale3finger'));
plotd = (fliplr(temp_schale1fingerground'));
plote = (fliplr(temp_schalehandgrund'));


plot(period_freq, plota, '-g',period_freq, plotb, '-k',period_freq, plotc, '-b',period_freq, plotd, '-r', period_freq, plote, '-m')
hleg1 = legend( 'Keine Berührung', 'Ein Finger', 'Drei Finger', 'Ein Finger am Grund', 'Handfläche am Grund');
xlabel('Frequenz kHz')
ylabel('Spannung Volt')
ylim([0.5 2.5]);



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