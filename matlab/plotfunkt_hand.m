%load('temp.mat');
plota = (fliplr(temp_2handnotouch'));
plotb = (fliplr(temp_2hand1finger'));
plotc = (fliplr(temp_2hand5finger'));
plotd = (fliplr(temp_2handgrasp'));
plote = (fliplr(temp_2handohren'));


plot(period_freq, plota, '-g',period_freq, plotb, '-k',period_freq, plotc, '-b',period_freq, plotd, '-r',period_freq, plote, '-m')
hleg1 = legend( 'Keine Berührung', 'Ein Finger', 'Fünf Finger', 'Hände verschränkt', 'Hände an Ohren');
xlabel('Frequenz kHz')
ylabel('Spannung Volt')
ylim([0.5 1.5]);



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