%load('temp.mat');
plota = (fliplr(temp_dataOFF));
plotb = (fliplr(temp_dataMA'));
plotc = (fliplr(temp_dataSG'));


plot(period_freq, plota, '-r',period_freq, plotb, '-m',period_freq, plotc, '-k')
hleg1 = legend('Kein Filter', 'Gleitender Mittelwert', 'Savitzky-Golay');
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