
%load('temp.mat');
plota = (fliplr(temp_glasnotouch'));
plotb = (fliplr(temp_glasfingeraussen'));
plotc = (fliplr(temp_glasdreifingeraussen'));
plotd = (fliplr(temp_glasfingereingetaucht'));
subplot(2,1,1); 




plot(period_freq, plota, '-g',period_freq, plotb, '-k',period_freq, plotc, '-b',period_freq, plotd, '-r')
%hleg1 = legend( 'Keine Berührung', 'Ein Finger aussen', 'Drei Finger aussen', 'Ein Finger eingetaucht');
ylim([0.8 2.3]);
xlim([1000 2000]);
xlabel('Frequenz kHz')
ylabel('Spannung Volt')
hleg1 = legend( 'Keine Berührung', 'Ein Finger aussen', 'Drei Finger aussen', 'Ein Finger eingetaucht');


%load('temp.mat');
plota = (fliplr(temp_glasnotouchSG'));
plotb = (fliplr(temp_glasfingeraussenSG'));
plotc = (fliplr(temp_glasdreifingeraussenSG'));
plotd = (fliplr(temp_glasfingereingetauchtSG'));


subplot(2,1,2);
plot(period_freq, plota, '-g',period_freq, plotb, '-k',period_freq, plotc, '-b',period_freq, plotd, '-r')

xlabel('Frequenz kHz')
ylabel('Spannung Volt')
ylim([0.8 2.3]);
xlim([1000 2000]);




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