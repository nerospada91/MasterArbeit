%load('temp.mat');
plota = (fliplr(temp_handynotouch'));
plotb = (fliplr(temp_handyrechts'));
plotc = (fliplr(temp_handyleft'));
plotd = (fliplr(temp_handybeidhaendig'));
plote = (fliplr(temp_handywagerecht2finger'));


plot(period_freq, plota, '-g',period_freq, plotb, '-k',period_freq, plotc, '-b',period_freq, plotd, '-r', period_freq, plote, '-m')
hleg1 = legend( 'Keine Berührung', 'Rechte Hand', 'Linke Hand', 'Beidhändig', 'Wagerecht');
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