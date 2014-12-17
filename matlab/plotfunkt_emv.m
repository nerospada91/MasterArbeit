%load('temp.mat');
plota = (fliplr(temp_dataOFF));

plotb = awgn(temp_dataOFF, 20,'measured');
plotc = awgn(temp_dataOFF, 30,'measured');

plot(period_freq, plota, '-k',period_freq, plotb, '-r',period_freq, plotc, '-m')
hleg1 = legend('Abgeschirmter Raum', 'Universität', 'Klinik');
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