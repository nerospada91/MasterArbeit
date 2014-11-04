%load('temp.mat');
plota = (fliplr(temp_dataOFF));
plotb = (fliplr(temp_dataMA'));
plotc = (fliplr(temp_dataSG'));


plot(period_freq, plota, '-g',period_freq, plotb, '-r',period_freq, plotc, '-b')
hleg1 = legend('kein Filter', 'Moving Average', 'Segerogy');
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