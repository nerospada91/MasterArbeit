%load('temp.mat');
plota = (fliplr(temp_ohne'));
plotb = (fliplr(temp_rechts'));


plot(period_freq, plota, '-g',period_freq, plotb, '-r')
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