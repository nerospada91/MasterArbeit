%load('temp.mat');
plota = (fliplr(temp_tischnotpresent'));
plotb = (fliplr(temp_tischnotouch'));
plotc = (fliplr(temp_tisch1hand'));
plotd = (fliplr(temp_tisch2hand'));
plote = (fliplr(temp_tisch1ellenborgen'));
plotf = (fliplr(temp_tisch2ellenbogen'));
plotg = (fliplr(temp_tischarmeflach'));

plot(period_freq, plota, '-c',period_freq, plotb, '-g',period_freq, plotc, '-b',period_freq, plotd, '-r', period_freq, plote, '-y', period_freq, plotf, '-k', period_freq, plotg, '-m')
hleg1 = legend( 'Nicht Präsent','Keine Berührung', 'Ein Arm', 'Zwei Arme', 'Ein Ellenbogen', 'Zwei Ellenbogen', 'Arme flach aufliegend');
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