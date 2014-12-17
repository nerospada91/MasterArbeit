%load('temp.mat');
plota = (fliplr(temp_data33'));
plotb = (fliplr(temp_data66'));
plotc = (fliplr(temp_dat1'));
plotd = (fliplr(temp_data10'));

plot(period_freq, plota, '-g',period_freq, plotb, '-r',period_freq, plotc, '-b',period_freq, plotd, '-k')
hleg1 = legend('0,33mH', '0,66mH', '1mH', '10mH');
xlabel('Frequenz kHz')
ylabel('Spannung Volt')
ylim([0 2.5]);



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