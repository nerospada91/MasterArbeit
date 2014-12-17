%load('temp.mat');
plota = (fliplr((temp_dataMA)'));
plotb = (fliplr((temp_dataMA*0.99)'));
plotc = (fliplr((temp_dataMA*0.98)'));


plot(period_freq, plota, '-r',period_freq, plotb, '-m',period_freq, plotc, '-k')
hleg1 = legend('Tag 1', 'Tag 2', 'Tag 3');
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