%load('temp.mat');
plot1 = (fliplr(temp_zu1'));
plot2 = (fliplr(temp_zu2'));
plot3 = (fliplr(temp_zu3'));
plot4 = (fliplr(temp_zu4'));
plot5 = (fliplr(temp_zu5'));
plot6 = (fliplr(temp_zu6'));
plot7 = (fliplr(temp_zu7'));

plot11 = (fliplr(temp_offen1'));
plot12 = (fliplr(temp_offen2'));
plot13 = (fliplr(temp_offen3'));
plot14 = (fliplr(temp_offen4'));
plot15 = (fliplr(temp_offen5'));
plot16 = (fliplr(temp_offen6'));
plot17 = (fliplr(temp_offen7'));

plot21 = (fliplr(temp_mittel1'));
plot22 = (fliplr(temp_mittel2'));
plot23 = (fliplr(temp_mittel3'));
plot24 = (fliplr(temp_mittel4'));
plot25 = (fliplr(temp_mittel5'));
plot26 = (fliplr(temp_mittel6'));
plot27 = (fliplr(temp_mittel7'));

    plot(period_freq, plot1, '-g',   period_freq, plot2, '-k',    period_freq, plot3, '-y', period_freq, plot4, '-m',period_freq, plot5, '-r',    period_freq, plot6, '-b',period_freq, plot7, '-k', ... 
         period_freq, plot11, '--g',period_freq, plot12, '--k',period_freq, plot13, '--y',period_freq, plot14, '--m',period_freq, plot15, '--r',period_freq, plot16, '--b',period_freq, plot17, '--k',...
         period_freq, plot21, '-og',period_freq, plot22, '-ok',period_freq, plot23, '-oy',period_freq, plot24, '-om',period_freq, plot25, '-or',period_freq, plot26, '-ob',period_freq, plot27, '-ok')
%plot(period_freq, plot1, '-g', period_freq, plot2, '-k',period_freq, plot3, '-r',...
 %   period_freq, plot11, '--g',period_freq, plot12, '--k',period_freq, plot13, '--r')
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