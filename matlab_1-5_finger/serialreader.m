try
    
    % prescale_ary=[8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,4,4,4,4,4,2,2,2,2,2,2,2,...
    %     1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,...
    %     1,1,1,1]';
    % period_ary = [2625,146,75,50,38,31,25,22,19,17,15,14,13,12,11,10,19,18,...
    %     17,16,15,29,28,27,26,25,24,23,44,43,41,40,39,37,36,35,34,33,32,31,...
    %     30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6]';
    %
    % period_freq = ones(65,1)*21;
    
    prescale_ary=ones(200,1);
    period_ary = [21000,10500,7000,5250,4200,3500,3000,2625,2333,2100,1909,1750,1615,1500,1400,1313,1235,1167,1105,1050,1000,955,913,875,840,808,778,750,724,700,677,656,636,618,600,583,568,553,538,525,512,500,488,477,467,457,447,438,429,420,412,404,396,389,382,375,368,362,356,350,344,339,333,328,323,318,313,309,304,300,296,292,288,284,280,276,273,269,266,263,259,256,253,250,247,244,241,239,236,233,231,228,226,223,221,219,216,214,212,210,208,206,204,202,200,198,196,194,193,191,189,188,186,184,183,181,179,178,176,175,174,172,171,169,168,167,165,164,163,162,160,159,158,157,156,154,153,152,151,150,149,148,147,146,145,144,143,142,141,140,139,138,137,136,135,133,131,130,128,127,125,124,122,121,119,118,117,115,114,113,112,111,109,108,107,106,105,104,103,102,101,100,99,98,97,96,95,95,94,93,92,91,90,89,88,88,87,86,85,84]';
    period_freq = ones(200,1)*21;
    
    period_freq = (period_freq ./ prescale_ary ./ period_ary)*1000;
    
    i=1;
    
    %BLUETOOTH!!!
    btt = Bluetooth('TOUCHEE', 1);
    btt.InputBufferSize=5000000;
    %btt.Terminator = {'CR/LF' 'CR/LF'};
    fopen(btt);
    
    period_res = zeros(200,1);
    
    hLine = plot(period_freq, period_res);
    ylim([0 4100])
    
    while i>0
        %idn = fread(btt);
        idn=fscanf(btt);
        disp(idn);
%         period_res = zeros(200,1);
%         
%         indexend = strfind(idn, 'END');
%         
%         if indexend == 801
%             
%             period_res = zeros(200,1);
%             
%             for k=0:199
%                 if k == 0
%                     value_raw = idn(1:4);
%                     value_raw = strrep(value_raw, 'X', '');
%                     period_res(k+1) =  str2double(value_raw);
%                 else
%                     value_raw = idn(k*4+1:(k+1)*4);
%                     value_raw = strrep(value_raw, 'X', '');
%                     period_res(k+1) =  str2double(value_raw);
%                 end
%             end
%             
%         end
%         
%         set(hLine,'YData',period_res);  %Updaten der Kurve
%         drawnow %Steuerelement zwingen neu zu zeichnen
        
    end
    
    %disp(idn)
catch exp
    
    disp(exp)
    
    fclose(btt)
    
end