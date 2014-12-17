%load('temp.mat');
plota = (fliplr(temp_glasnotouch'));
plotb = (fliplr(temp_glasfingeraussen'));
plotc = (fliplr(temp_glasdreifingeraussen'));
plotd = (fliplr(temp_glasfingereingetaucht'));




plot(period_freq, plota, '-g',period_freq, plotb, '-k',period_freq, plotc, '-b',period_freq, plotd, '-r')
hleg1 = legend( 'Keine Berührung', 'Ein Finger aussen', 'Drei Finger aussen', 'Ein Finger eingetaucht');
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