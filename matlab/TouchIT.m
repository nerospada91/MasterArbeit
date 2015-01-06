function varargout = TouchIT(varargin)
% TOUCHIT MATLAB code for TouchIT.fig
%      TOUCHIT, by itself, creates a new TOUCHIT or raises the existing
%      singleton*.
%
%      H = TOUCHIT returns the handle to a new TOUCHIT or the handle to
%      the existing singleton*.
%
%      TOUCHIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOUCHIT.M with the given input arguments.
%
%      TOUCHIT('Property','Value',...) creates a new TOUCHIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TouchIT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TouchIT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TouchIT

% Last Modified by GUIDE v2.5 06-Jan-2015 00:34:45
global rec_dat;
rec_dat = [];
global countit
countit = 1;

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TouchIT_OpeningFcn, ...
    'gui_OutputFcn',  @TouchIT_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT


% --- Executes just before TouchIT is made visible.
function TouchIT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TouchIT (see VARARGIN)

% Choose default command line output for TouchIT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TouchIT wait for user response (see UIRESUME)
% uiwait(handles.TouchIT_main);


% --- Outputs from this function are returned to the command line.
function varargout = TouchIT_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_con.
function pb_con_Callback(hObject, eventdata, handles)
% hObject    handle to pb_con (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ad9850 = 1;

%STM32
if (ad9850 == 0)
    
    period_ary = [64615,11507,6316,4352,3320,2684,2252,1940,1704,1519,...
        1370,1248,1146,1059,985,920,863,813,769,729,692,660,630,603,578,...
        555,534,514,496,479,463,448,435,421,409,398,387,376,366,357,348,...
        340,332,324,317,310,303,297,290,284,279,273,268,263,258,254,249,...
        245,240,236,232,229,225,221,218,215,211,208,205,202,199,197,194,...
        191,189,185,182,179,176,173,170,168,165,162,160,158,155,153,151,...
        149,147,145,143,141,139,137,135,133,132,130,129,127,126,124,123,...
        121,120,118,117,116,115,113,112,111,110,109,108,106,105,104,103,...
        102,101,100,99,98,97,96,95,94,93,92,91,90,89,88,87,86,85,84,83,...
        82,81,80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64,63,62,...
        61,60,59,58,57,56,55,54,53,52,51,50,49,48,47,46,45,44,43,42,41,...
        40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24]';
    
    period_freq = 84000000./period_ary/1000;
    
    
    
else
    
    %AD9850
    
    period_ary = [1000,5300,22950,40600,58250,75900,93550,111200,128850,...
        146500,164150,181800,199450,217100,234750,252400,270050,287700,305350,...
        323000,340650,358300,375950,393600,411250,428900,446550,464200,481850,...
        499500,517150,534800,552450,570100,587750,605400,623050,640700,658350,...
        676000,693650,711300,728950,746600,764250,781900,799550,817200,834850,...
        852500,870150,887800,905450,923100,940750,958400,976050,993700,1011350,...
        1029000,1046650,1064300,1081950,1099600,1117250,1134900,1152550,1170200,...
        1187850,1205500,1223150,1240800,1258450,1276100,1293750,1311400,1329050,...
        1346700,1364350,1382000,1399650,1417300,1434950,1452600,1470250,1487900,...
        1505550,1523200,1540850,1558500,1576150,1593800,1611450,1629100,1646750,...
        1664400,1682050,1699700,1717350,1735000,1752650,1770300,1787950,1805600,...
        1823250,1840900,1858550,1876200,1893850,1911500,1929150,1946800,1964450,...
        1982100,1999750,2017400,2035050,2052700,2070350,2088000,2105650,2123300,...
        2140950,2158600,2176250,2193900,2211550,2229200,2246850,2264500,2282150,...
        2299800,2317450,2335100,2352750,2370400,2388050,2405700,2423350,2441000,...
        2458650,2476300,2493950,2511600,2529250,2546900,2564550,2582200,2599850,...
        2617500,2635150,2652800,2670450,2688100,2705750,2723400,2741050,2758700,...
        2776350,2794000,2811650,2829300,2846950,2864600,2882250,2899900,2917550,...
        2935200,2952850,2970500,2988150,3005800,3023450,3041100,3058750,3076400,...
        3094050,3111700,3129350,3147000,3164650,3182300,3199950,3217600,3235250,...
        3252900,3270550,3288200,3305850,3323500,3341150,3358800,3376450,3394100,...
        3411750,3429400,3447050,3464700,3482350,3500000]';
    
    
    period_freq = period_ary/1000;
end

ary = [3200,2667,2286,2000,1778,1600,1455,1333,1231,1143,1067,...
    1000,941,889,842,800,762,727,696,667,640,615,593,571,552,533,516,500,485,...
    471,457,444,432,421,410,400,390,381,372,364,356,348,340,333,327,320,314,...
    308,302,296,291,286,281,276,271,267,262,258,254,250,246,242,239,235,232,...
    229,225,222,219,216,213,211,208,205,203,200,198,195,193,190,188,186,184,...
    182,180,178,176,174,172,170,168,167,165,163,162,160,158,157,155,154,152,...
    151,150,148,147,145,144,143,142,140,139,138,137,136,134,133,132,131,130,...
    129,128,127,126,125,124,123,122,121,120,119,119,118,117,116,115,114,113,...
    113,112,111,110,110,109,108,107,107,106,105,105,104,103,103,102,101,101,...
    100,99,99,98,98,97,96,96,95,95,94,94,93,92,92,91,91,90,90,89,89,88,88,87,...
    87,86,86,86,85,85,84,84,83,83,82,82,82,81,81,80,80,80,80,80,80];

%per_ard_freq = (flip(ary))';


%per_new = zeros(size(per_ard_freq));

% for t = 1:size(per_ard_freq)
%
%     f= period_freq;
%
%     val = per_ard_freq(t); %value to find
%     tmp = abs(f-val);
%     [idx idx] = min(tmp); %index of closest value
%     closest = f(idx); %closest value
%     %%%%%%%%%%%%%%%%%%%
%
%     per_new(t) = idx;
%
% end
i=1;

%BLUETOOTH!!!
btt = Bluetooth('TOUCHEE', 1);
btt.InputBufferSize=5000000;
fopen(btt);

set(0,'userdata',1)

period_res = zeros(200,1);

hLine = plot(period_freq, period_res);
%hLine = plot(1:200, period_res);
ylim([0 5])

%xlim([1, 250])

touchit_gui_data = guidata(handles.TouchIT_main);
touchit_gui_data.btt = btt;
touchit_gui_data.axesplot = hLine;
touchit_gui_data.record = 0;
touchit_gui_data.save = 0;
touchit_gui_data.filter = 1;
touchit_gui_data.arduino = 0;
touchit_gui_data.capture = 0;
guidata(handles.TouchIT_main,touchit_gui_data)
firstshot = 1;
firstcache = 1;
cachesize = 20;
cache_volt = 1;


while 1
    
    %     z=z+1;
    %     disp(z);
    
    idn = fscanf(btt);
    
    period_res = zeros(200,1);
    
    indexend = strfind(idn, 'END');
    
    if indexend == 801
        
        period_res = zeros(200,1);
        
        for k=0:199
            if k == 0
                value_raw = idn(1:4);
                value_raw = strrep(value_raw, 'X', '');
                period_res(k+1) =  str2double(value_raw);
            else
                value_raw = idn(k*4+1:(k+1)*4);
                value_raw = strrep(value_raw, 'X', '');
                period_res(k+1) =  str2double(value_raw);
            end
        end
        
    end
    
    
    period_res(1) = period_res(4);
    period_res(2) = period_res(4);
    period_res(3) = period_res(4);
    
    
    if (touchit_gui_data.arduino == 1)
        
        period_ar_volt = period_res(per_new);
        period_res = period_ar_volt;
        %set(gca,'XLim',[1 200]);
        
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%FILTER
    
    if (touchit_gui_data.filter == 1)
        
        iN = 5; % Länge des Filters
        [period_filt]  = filter(ones(1,iN)/iN, 1, period_res);
        
        
        if (firstshot == 1)
            
            period_volt = period_filt*0.0012;
            
            firstshot = 0;
            
            period_volt_cache = period_volt';
            
        else
            
            period_volt = get(hLine,'YData')*0.5 + ((period_filt*0.0012)*0.5)';
            %period_volt = period_filt*0.0012;
            
        end
        
    else
        
        if (touchit_gui_data.filter == 2)
            
            [period_filt]  = sgolayfilt(period_res,3,9);
            period_volt = get(hLine,'YData')*0.5 + ((period_filt*0.0012)*0.5)';
            
        else
            
            period_volt =  period_res*0.0012;
        end
        
    end
    
    
    if (firstcache == 1)
        
        if cachesize ~= size(period_volt_cache, 1)
            
            period_volt_cache(cache_volt,:) = period_volt';
            
        else
            
            firstcache = 0;
        end
        
        cache_volt = cache_volt + 1;
    else
        
        period_volt_cache(1,:) = [];
        period_volt_cache(cachesize,:) = period_volt';
        
    end
    
    %     iN = 5; % Länge des Filters
    %     [period_volt]  = filter(ones(1,iN)/iN, 1, period_volt);
    %period_volt = period_volt*0.0012;
    
    %%%%%%%%%%%%%%%%%%%% FILTER ENDE
    %plot(period_freq, period_res)
    
    set(hLine,'YData',period_volt);  %Updaten der Kurve
    
    if (touchit_gui_data.capture == 1)
        
        set(gcf,'PaperUnits','inches','PaperPosition',[0 0 9 7.25])
        print -djpeg capture.jpg -r100
        touchit_gui_data.capture = 0;
        guidata(handles.TouchIT_main,touchit_gui_data)
    end
    
    
    drawnow %Steuerelement zwingen neu zu zeichnen
    
    if get(0,'userdata') == 0
        break
    end
    
    touchit_gui_data = guidata(handles.TouchIT_main);
    
    
    
    if (touchit_gui_data.record == 1)
        
        record_rawdata(period_volt);
        
    end
    
    if (touchit_gui_data.save == 1)
        
        
        if touchit_gui_data.countsave < 201
            
            temp_data(touchit_gui_data.countsave,:) = period_volt;
            
            touchit_gui_data.countsave=touchit_gui_data.countsave+1;
            guidata(touchit_gui_data.TouchIT_main, touchit_gui_data)
            
        else
            
            temp_data = mean(temp_data);
            save('temp.mat', 'temp_data', 'period_freq')
            touchit_gui_data.save = 0;
            guidata(touchit_gui_data.TouchIT_main, touchit_gui_data)
            
            
        end
    end
    
    
    
    
    if     strcmp(get(touchit_gui_data.txt_nc, 'String'), 'RUNNING')
        
        
        period_volt_mittelw = sum(period_volt_cache)/cachesize;
        
        %Wasserglas TEST1
        
        if isequal(get(touchit_gui_data.pb_wasserglas, 'BackgroundColor'), [0 1 0]);
            
            
            
            erg = zeros(4,1);
            h = sum(touchit_gui_data.notouch)/59;
            h = [h(50:80); period_volt_mittelw(50:80)];
            erg(1) = sum(abs(diff(h)));
            
            h = sum(touchit_gui_data.onefinger)/59;
            h = [h(50:80); period_volt_mittelw(50:80)];
            erg(2) = sum(abs(diff(h)));
            
            h = sum(touchit_gui_data.fivefingers)/59;
            h = [h(50:80); period_volt_mittelw(50:80)];
            erg(3) = sum(abs(diff(h)));
            
            h = sum(touchit_gui_data.grasp)/59;
            h = [h(50:80); period_volt_mittelw(50:80)];
            erg(4) = sum(abs(diff(h)));
            
%             h = sum(touchit_gui_data.coverears)/59;
%             h = [h(50:80); period_volt_mittelw(50:80)];
%             erg(5) = sum(abs(diff(h)));
            %e=10000;
            

            [k]=find(erg==min(min(erg)));

            
            
            if (k == 1)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', 'green');
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            if (k == 2)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor','green');
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            if (k == 3)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor','green');
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            
            if (k == 4)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', 'green');
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
        end
            %ALLE ANDEREN - SMARTPHONE
            
        if isequal(get(touchit_gui_data.pb_smartp, 'BackgroundColor'), [0 1 0]);
                    
            erg = zeros(4,1);
            erg_sec = zeros(4,1);
            
            h = sum(touchit_gui_data.notouch)/59;
            h = [h(20:65); period_volt_mittelw(20:65)];
            erg(1) = sum(abs(diff(h)));
            erg_sec(1) = sum(sum(abs(diff(h,1,2))));
            
            h = sum(touchit_gui_data.onefinger)/59;
            h = [h(11:70); period_volt_mittelw(11:70)];
            erg(2) = sum(abs(diff(h)));
            erg_sec(2) =sum(sum(abs(diff(h,1,2))));          
 
            h = sum(touchit_gui_data.fivefingers)/59;
            h = [h(40:70); period_volt_mittelw(40:70)];
            erg(3) = sum(abs(diff(h)));
            erg_sec(3) =sum(sum(abs(diff(h,1,2))));
            
            h = sum(touchit_gui_data.grasp)/59;
            h = [h(10:80); period_volt_mittelw(10:80)];
            erg(4) = sum(abs(diff(h)));
            erg_sec(4) =sum(sum(abs(diff(h,1,2))));
            
%             h = sum(touchit_gui_data.coverears)/59;
%             h = [h(10:80); period_volt_mittelw(10:80)];
%             erg(5) = sum(abs(diff(h)));
%             erg_sec(5) =sum(sum(abs(diff(h,1,2))));
%             %e=10000;
           
            [k]=find(erg==min(min(erg)));

            %[k]=find(erg_sec==min(min(erg_sec)));

            disp([num2str(erg(1)) ' ' num2str(erg(2)) ' ' num2str(erg(3)) ' ' num2str(erg(4))])

            %disp([num2str(erg_sec(1)) ' ' num2str(erg_sec(2)) ' ' num2str(erg_sec(3)) ' ' num2str(erg_sec(4)) ' ' num2str(erg_sec(5))])
                        
            
            if (k == 1)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', 'green');
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            if (k == 2)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor','green');
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            if (k == 3)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor','green');
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            
            if (k == 4)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', 'green');
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            
            if (k == 5)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', 'green');
            end
            
        end
        
        %TÜRKNAUF
        
       if isequal(get(touchit_gui_data.pb_door, 'BackgroundColor'), [0 1 0]);
                    
            erg = zeros(5,1);
            erg_sec = zeros(5,1);
            
            h = sum(touchit_gui_data.notouch)/59;
            h = [h(50:80); period_volt_mittelw(50:80)];
            erg(1) = sum(abs(diff(h)));
            erg_sec(1) = sum(sum(abs(diff(h,1,2))));
            
            h = sum(touchit_gui_data.onefinger)/59;
            h = [h(50:80); period_volt_mittelw(50:80)];
            erg(2) = sum(abs(diff(h)));
            erg_sec(2) =sum(sum(abs(diff(h,1,2))));          
 
            h = sum(touchit_gui_data.fivefingers)/59;
            h = [h(50:80); period_volt_mittelw(50:80)];
            erg(3) = sum(abs(diff(h)));
            erg_sec(3) =sum(sum(abs(diff(h,1,2))));
            
            h = sum(touchit_gui_data.grasp)/59;
            h = [h(50:80); period_volt_mittelw(50:80)];
            erg(4) = sum(abs(diff(h)));
            erg_sec(4) =sum(sum(abs(diff(h,1,2))));
            
            h = sum(touchit_gui_data.coverears)/59;
            h = [h(50:80); period_volt_mittelw(50:80)];
            erg(5) = sum(abs(diff(h)));
            erg_sec(5) =sum(sum(abs(diff(h,1,2))));
            %e=10000;
           
            [k]=find(erg==min(min(erg)));

            %[k]=find(erg_sec==min(min(erg_sec)));

            disp([num2str(erg(1)) ' ' num2str(erg(2)) ' ' num2str(erg(3)) ' ' num2str(erg(4)) ' ' num2str(erg(5))])

            %disp([num2str(erg_sec(1)) ' ' num2str(erg_sec(2)) ' ' num2str(erg_sec(3)) ' ' num2str(erg_sec(4)) ' ' num2str(erg_sec(5))])
                        
            
            if (k == 1)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', 'green');
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            if (k == 2)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor','green');
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            if (k == 3)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor','green');
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            
            if (k == 4)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', 'green');
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            
            if (k == 5)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', 'green');
            end
            
       end
        
           
       if isequal(get(touchit_gui_data.pb_touch, 'BackgroundColor'), [0 1 0]);
                    
            erg = zeros(5,1);
            erg_sec = zeros(5,1);
            
            h = sum(touchit_gui_data.notouch)/59;
            h = [h(2:30); period_volt_mittelw(2:30)];
            erg(1) = sum(abs(diff(h)));
            erg_sec(1) = sum(sum(abs(diff(h,1,2))));
            
            h = sum(touchit_gui_data.onefinger)/59;
            h = [h(2:30); period_volt_mittelw(2:30)];
            erg(2) = sum(abs(diff(h)));
            erg_sec(2) =sum(sum(abs(diff(h,1,2))));          
 
            h = sum(touchit_gui_data.fivefingers)/59;
            h = [h(2:30); period_volt_mittelw(2:30)];
            erg(3) = sum(abs(diff(h)));
            erg_sec(3) =sum(sum(abs(diff(h,1,2))));
            
            h = sum(touchit_gui_data.grasp)/59;
            h = [h(2:30); period_volt_mittelw(2:30)];
            erg(4) = sum(abs(diff(h)));
            erg_sec(4) =sum(sum(abs(diff(h,1,2))));
            
            h = sum(touchit_gui_data.coverears)/59;
            h = [h(2:30); period_volt_mittelw(2:30)];
            erg(5) = sum(abs(diff(h)));
            erg_sec(5) =sum(sum(abs(diff(h,1,2))));
            %e=10000;
           
            [k]=find(erg==min(min(erg)));

            %[k]=find(erg_sec==min(min(erg_sec)));

            disp([num2str(erg(1)) ' ' num2str(erg(2)) ' ' num2str(erg(3)) ' ' num2str(erg(4)) ' ' num2str(erg(5))])

            %disp([num2str(erg_sec(1)) ' ' num2str(erg_sec(2)) ' ' num2str(erg_sec(3)) ' ' num2str(erg_sec(4)) ' ' num2str(erg_sec(5))])
                        
            
            if (k == 1)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', 'green');
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            if (k == 2)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor','green');
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            if (k == 3)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor','green');
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            
            if (k == 4)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', 'green');
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            end
            
            
            if (k == 5)
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', 'green');
            end
            
        end
        
        
        
        % k = 1;
        %
        % if b > a
        %
        %     k = 2;
        %
        %     if c > b
        %
        %         k = 3;
        %
        %     end
        %
        %     if d > c
        %
        %         k = 4;
        %
        %     end
        %
        %     if e > d
        %
        %         k = 5;
        %
        %     end
        %
        %
        % end
        
        
        %                 set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
        
        
        %         s_data = [touchit_gui_data.notouch; touchit_gui_data.onefinger; touchit_gui_data.fivefingers; touchit_gui_data.grasp; touchit_gui_data.coverears];
        %
        %         for j=1:5
        %             if j == 1
        %                 s_class(1:60) = j;
        %             else
        %                 s_class((j-1)*60:(j)*60) = j;
        %             end
        %         end
        %         s_class = s_class';
        
        %         s_data = [touchit_gui_data.notouch; touchit_gui_data.onefinger; touchit_gui_data.fivefingers; touchit_gui_data.grasp];
        %
        %         for j=1:4
        %             if j == 1
        %                 s_class(1:60) = j;
        %             else
        %                 s_class((j-1)*60:(j)*60) = j;
        %             end
        %         end
        %         s_class = s_class';
        %
        %         results = multisvm(s_data, s_class, period_volt);
        %
        %         switch results
        %             case 1
        %                 set(touchit_gui_data.pb_notouch, 'BackgroundColor', 'green');
        %                 set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
        %             case 2
        %                 set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_onefinger, 'BackgroundColor','green');
        %                 set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
        %             case 3
        %                 set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_fivefingers, 'BackgroundColor','green');
        %                 set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
        %             case 4
        %                 set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_grasp, 'BackgroundColor', 'green');
        %                 set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
        %             case 5
        %                 set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_coverears, 'BackgroundColor', 'green');
        %         end
        %
        %
        % h = sum(touchit_gui_data.notouch)/59;
        % a = corrcoef(h(50:80)', period_volt(50:80)');
        %
        % h = sum(touchit_gui_data.onefinger)/59;
        % b = corrcoef(h(50:80)', period_volt(50:80)');
        %
        % h = sum(touchit_gui_data.fivefingers)/59;
        % c = corrcoef(h(50:80)', period_volt(50:80)');
        %
        % h = sum(touchit_gui_data.grasp)/59;
        % d = corrcoef(h(50:80)', period_volt(50:80)');
        %
        % h = sum(touchit_gui_data.coverears)/59;
        % e = corrcoef(h(50:80)', period_volt(50:80)');
        
        % b = corr((sum(touchit_gui_data.onefinger)/59)', period_volt');
        %
        % c = corr((sum(touchit_gui_data.fivefingers)/59)', period_volt');
        %
        % d = corr((sum(touchit_gui_data.grasp)/59)', period_volt');
        %
        % e = corr((sum(touchit_gui_data.coverears)/59)', period_volt');
        
        
        
        %                 k1 = svmclassify(touchit_gui_data.model1,period_volt);
        %
        %                 k2 = svmclassify(touchit_gui_data.model2,period_volt);
        %
        %                 k3 = svmclassify(touchit_gui_data.model3,period_volt);
        %
        %                 k4 = svmclassify(touchit_gui_data.model4,period_volt);
        %
        %                 k5 = svmclassify(touchit_gui_data.model5,period_volt);
        
        %                 set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
        %
        %                 if (k1 == 1)
        %                     set(touchit_gui_data.pb_notouch, 'BackgroundColor', 'green');
        %                     set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 end
        %
        %                 if (k2 == 2)
        %                     set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_onefinger, 'BackgroundColor','green');
        %                     set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 end
        %
        %                 if (k3 == 3)
        %                     set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_fivefingers, 'BackgroundColor','green');
        %                     set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 end
        %
        %
        %                 if (k4 == 4)
        %                     set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_grasp, 'BackgroundColor', 'green');
        %                     set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
        %                 end
        %
        %
        %                 if (k5 == 5)
        %                     set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
        %                     set(touchit_gui_data.pb_coverears, 'BackgroundColor', 'green');
        %                 end
        
        
        
        
    end
    
    
    
    touchit_gui_data = guidata(handles.TouchIT_main);
    guidata(touchit_gui_data.TouchIT_main, touchit_gui_data)
    
end


% --- Executes when user attempts to close TouchIT_main.
function TouchIT_main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to TouchIT_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exit(handles);

% Hint: delete(hObject) closes the figure
delete(hObject);

function exit(handles)

touchit_gui_data = guidata(handles.TouchIT_main);

set(0,'userdata',0)

guidata(handles.TouchIT_main,touchit_gui_data)
if isfield(touchit_gui_data, 'btt')
    fclose(touchit_gui_data.btt);
end





% --- Executes on button press in pb_exit.
function pb_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exit(handles);
close;




% --- Executes on button press in pb_notouch.
function pb_notouch_Callback(hObject, eventdata, handles)
% hObject    handle to pb_notouch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_onefinger.
function pb_onefinger_Callback(hObject, eventdata, handles)
% hObject    handle to pb_onefinger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_fivefingers.
function pb_fivefingers_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fivefingers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_grasp.
function pb_grasp_Callback(hObject, eventdata, handles)
% hObject    handle to pb_grasp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_coverears.
function pb_coverears_Callback(hObject, eventdata, handles)
% hObject    handle to pb_coverears (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_train.
function pb_train_Callback(hObject, eventdata, handles)
% hObject    handle to pb_train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
train_loop(handles);

% --- Executes on button press in pb_go.
function pb_go_Callback(hObject, eventdata, handles)
% hObject    handle to pb_go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pb_go, 'BackgroundColor', 'green');
set(handles.txt_nc, 'String', 'RUNNING');


function train_loop(handles)



touchit_gui_data = guidata(handles.TouchIT_main);
set(touchit_gui_data.pb_go, 'BackgroundColor', [0.94 0.94 0.94]);

set(touchit_gui_data.txt_nc, 'String', 'NOT CALIBRATED');
set(touchit_gui_data.txt_nc, 'ForegroundColor', 'red');

touchit_gui_data.record = 1;
guidata(handles.TouchIT_main,touchit_gui_data)


% onefinger = 'set(handles.pb_notouch, ''BackgroundColor'', [0.94 0.94 0.94]);set(handles.pb_onefinger, ''BackgroundColor'', ''green'');';
%
% fivefingers = 'set(handles.pb_onefinger, ''BackgroundColor'', [0.94 0.94 0.94]);set(handles.pb_fivefingers, ''BackgroundColor'', ''green'');';
%
% grasp = 'set(handles.pb_fivefingers, ''BackgroundColor'', [0.94 0.94 0.94]);set(handles.pb_grasp, ''BackgroundColor'', ''green'');';
%
% coverears = 'set(handles.pb_grasp, ''BackgroundColor'', [0.94 0.94 0.94]);set(handles.pb_coverears, ''BackgroundColor'', ''green'');';
%
% stoptimer = 'set(handles.pb_coverears, ''BackgroundColor'', [0.94 0.94 0.94]); stop(T)';
%
% T=timer('TimerFcn',{@notouch});
% %T=timer('TimerFcn',[notouch onefinger fivefingers, grasp, coverears, stoptimer]);
% set(T,'Period',3,'ExecutionMode','fixedDelay');
%
% start(T)

touchit_gui_data.tmr = timer('TimerFcn', {@TmrFcn,handles},'BusyMode','Queue',...
    'ExecutionMode','fixedRate','Period',5);%timer

touchit_gui_data.timer = 1;

guidata(handles.TouchIT_main,touchit_gui_data);
start(touchit_gui_data.tmr);

function TmrFcn(src,event,handles) %Timer function
global rec_dat;

%59 samples // 19 samples
training_samples = 59;

touchit_gui_data = guidata(handles.TouchIT_main);
%touchit_gui_data.record = 0;

if (touchit_gui_data.timer == 1)
    touchit_gui_data.record = 1;
    set(touchit_gui_data.pb_notouch, 'BackgroundColor', 'green');
end

if (touchit_gui_data.timer == 2)
    touchit_gui_data.notouch = rec_dat(end-training_samples:end,:);
    rec_dat = [];
    set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
    set(touchit_gui_data.pb_onefinger, 'BackgroundColor', 'green');
end

if (touchit_gui_data.timer == 3)
    touchit_gui_data.onefinger = rec_dat(end-training_samples:end,:);
    rec_dat = [];
    set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
    set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', 'green');
end

if (touchit_gui_data.timer == 4)
    touchit_gui_data.fivefingers = rec_dat(end-training_samples:end,:);
    rec_dat = [];
    set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
    set(touchit_gui_data.pb_grasp, 'BackgroundColor', 'green');
end

if (touchit_gui_data.timer == 5)
    touchit_gui_data.grasp = rec_dat(end-training_samples:end,:);
    rec_dat = [];
    set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
    set(touchit_gui_data.pb_coverears, 'BackgroundColor', 'green');
end

if (touchit_gui_data.timer == 6)
    touchit_gui_data.coverears = rec_dat(end-training_samples:end,:);
    touchit_gui_data.record = 0;
    rec_dat = [];
    set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
    stop(touchit_gui_data.tmr);
    delete(touchit_gui_data.tmr);
    
    %HIER SVM AKTIVIEREN!!!!
    %touchit_gui_data = train_svm(touchit_gui_data,training_samples);
    
    set(touchit_gui_data.txt_nc, 'String', 'CALIBRATED');
    set(touchit_gui_data.txt_nc, 'ForegroundColor', 'green');
end


touchit_gui_data.timer = touchit_gui_data.timer +1;
guidata(handles.TouchIT_main,touchit_gui_data);

function [touchit_gui_data] = train_svm(touchit_gui_data,training_samples)

s_data = [touchit_gui_data.notouch; touchit_gui_data.onefinger; touchit_gui_data.fivefingers; touchit_gui_data.grasp; touchit_gui_data.coverears];
s_class = ones((training_samples+1)*5,1);
s_class(1:training_samples+1) = 1;
s_class(training_samples+2:(training_samples+1)*5) = 6;

SVMstruct1 = svmtrain(s_data, s_class);

touchit_gui_data.model1 = SVMstruct1;

s_data = [touchit_gui_data.onefinger; touchit_gui_data.notouch; touchit_gui_data.fivefingers; touchit_gui_data.grasp; touchit_gui_data.coverears];
s_class = ones((training_samples+1)*5,1);
s_class(1:training_samples+1) = 2;
s_class(training_samples+2:(training_samples+1)*5) = 6;

SVMstruct2 = svmtrain(s_data, s_class);

touchit_gui_data.model2 = SVMstruct2;

s_data = [touchit_gui_data.fivefingers; touchit_gui_data.onefinger; touchit_gui_data.notouch; touchit_gui_data.grasp; touchit_gui_data.coverears];
s_class = ones((training_samples+1)*5,1);
s_class(1:training_samples+1) = 3;
s_class(training_samples+2:(training_samples+1)*5) = 6;

SVMstruct3 = svmtrain(s_data, s_class);

touchit_gui_data.model3 = SVMstruct3;

s_data = [touchit_gui_data.grasp; touchit_gui_data.onefinger; touchit_gui_data.fivefingers; touchit_gui_data.notouch; touchit_gui_data.coverears];
s_class = ones((training_samples+1)*5,1);
s_class(1:training_samples+1) = 4;
s_class(training_samples+2:(training_samples+1)*5) = 6;

SVMstruct4 = svmtrain(s_data, s_class);

touchit_gui_data.model4 = SVMstruct4;

s_data = [touchit_gui_data.coverears; touchit_gui_data.onefinger; touchit_gui_data.fivefingers; touchit_gui_data.grasp; touchit_gui_data.notouch];
s_class = ones((training_samples+1)*5,1);
s_class(1:training_samples+1) = 5;
s_class(training_samples+2:(training_samples+1)*5) = 6;

SVMstruct5 = svmtrain(s_data, s_class);

touchit_gui_data.model5 = SVMstruct5;

% 1 2 3 4 5
% s_data = [touchit_gui_data.notouch; touchit_gui_data.onefinger];
% s_class = ones(40,1);
% s_class(1:20) = 1;
% s_class(21:40) = 2;
% %notouch vs onefinger
% SVMstruct1 = svmtrain(s_data,s_class);

% s_data = [touchit_gui_data.onefinger; touchit_gui_data.notouch];
% SVMstruct2 = svmtrain(s_data,s_class);
%
% s_data = [touchit_gui_data.fivefingers; touchit_gui_data.notouch];
% SVMstruct3 = svmtrain(s_data,s_class);
%
% s_data = [touchit_gui_data.grasp; touchit_gui_data.notouch];
% SVMstruct4 = svmtrain(s_data,s_class);
%
% s_data = [touchit_gui_data.coverears; touchit_gui_data.notouch];
% SVMstruct5 = svmtrain(s_data,s_class);


% touchit_gui_data.model2 = SVMstruct2;
% touchit_gui_data.model3 = SVMstruct3;
% touchit_gui_data.model4 = SVMstruct4;
% touchit_gui_data.model5 = SVMstruct5;

% s_data = [touchit_gui_data.notouch; touchit_gui_data.onefinger; touchit_gui_data.fivefingers; touchit_gui_data.grasp; touchit_gui_data.coverears];
% s_class = ones(40,1);
% s_class(1:20) = 1;
% s_class(21:40) = 2;
% s_class(51:60) = 3;
% s_class(61:80) = 4;
% s_class(81:100) = 5;
%
% % SVMstruct = svmtrain(s_data,s_class,'linear','rbf');
%
% %save('temp.mat','touchit_gui_data');
%
% TrainingSet = s_data;
% GroupTrain = s_class;
% u=unique(GroupTrain);
% numClasses=length(u);
%
% %build models
% for k=1:numClasses
%     %Vectorized statement that binarizes Group
%     %where 1 is the current class and 0 is all other classes
%     G1vAll=(GroupTrain==u(k));
%     models(k) = svmtrain(TrainingSet,G1vAll);
% end
%
% touchit_gui_data.models = models;


function record_rawdata(period_volt)
global rec_dat;

if size(rec_dat, 1) == 0
    
    rec_dat(1,:) = period_volt;
    
else
    rec_dat(size(rec_dat,1)+1, :) = period_volt;
    
end

% switch case_x
%     case 'notoch'
%
%     case 'onefinger'
%
%     case 'fivefingers'
%
%     case 'grasp'
%
%     case 'coverears'
% end




% --- Executes on button press in pb_simulate.
function pb_simulate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_simulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% touchit_gui_data = guidata(handles.TouchIT_main);
%
% load('temp.mat')
%
%
% period_freq = temp_data';
%
%  period_ary = [1000,5300,22950,40600,58250,75900,93550,111200,128850,...
%         146500,164150,181800,199450,217100,234750,252400,270050,287700,305350,...
%         323000,340650,358300,375950,393600,411250,428900,446550,464200,481850,...
%         499500,517150,534800,552450,570100,587750,605400,623050,640700,658350,...
%         676000,693650,711300,728950,746600,764250,781900,799550,817200,834850,...
%         852500,870150,887800,905450,923100,940750,958400,976050,993700,1011350,...
%         1029000,1046650,1064300,1081950,1099600,1117250,1134900,1152550,1170200,...
%         1187850,1205500,1223150,1240800,1258450,1276100,1293750,1311400,1329050,...
%         1346700,1364350,1382000,1399650,1417300,1434950,1452600,1470250,1487900,...
%         1505550,1523200,1540850,1558500,1576150,1593800,1611450,1629100,1646750,...
%         1664400,1682050,1699700,1717350,1735000,1752650,1770300,1787950,1805600,...
%         1823250,1840900,1858550,1876200,1893850,1911500,1929150,1946800,1964450,...
%         1982100,1999750,2017400,2035050,2052700,2070350,2088000,2105650,2123300,...
%         2140950,2158600,2176250,2193900,2211550,2229200,2246850,2264500,2282150,...
%         2299800,2317450,2335100,2352750,2370400,2388050,2405700,2423350,2441000,...
%         2458650,2476300,2493950,2511600,2529250,2546900,2564550,2582200,2599850,...
%         2617500,2635150,2652800,2670450,2688100,2705750,2723400,2741050,2758700,...
%         2776350,2794000,2811650,2829300,2846950,2864600,2882250,2899900,2917550,...
%         2935200,2952850,2970500,2988150,3005800,3023450,3041100,3058750,3076400,...
%         3094050,3111700,3129350,3147000,3164650,3182300,3199950,3217600,3235250,...
%         3252900,3270550,3288200,3305850,3323500,3341150,3358800,3376450,3394100,...
%         3411750,3429400,3447050,3464700,3482350,3500000]';
%
%     period_ary = period_ary/1000;
%
%     period_ary_arduino = [8000,5333.333,4000,3200,2666.666,2285.714,2000,...
%         1777.777,1600,1454.545,1333.333,1230.769,1142.857,1066.666,1000,...
%         941.176,888.888,842.105,800,761.904,727.272,695.652,666.666,640,...
%         615.384,592.592,571.428,551.724,533.333,516.129,500,484.848,...
%         470.588,457.142,444.444,432.432,421.052,410.256,400,390.243,...
%         380.952,372.093,363.636,355.555,347.826,340.425,333.333,326.53,...
%         320,313.725,307.692,301.886,296.296,290.909,285.714,280.701,...
%         275.862,271.186,266.666,262.295,258.064,253.968,250,246.153,...
%         242.424,238.805,235.294,231.884,228.571,225.352,222.222,219.178,...
%         216.216,213.333,210.526,207.792,205.128,202.531,200,197.53,...
%         195.121,192.771,190.476,188.235,186.046,183.908,181.818,179.775,...
%         177.777,175.824,173.913,172.043,170.212,168.421,166.666,164.948,...
%         163.265,161.616,160,158.415,156.862,155.339,153.846,152.38,...
%         150.943,149.532,148.148,146.788,145.454,144.144,142.857,...
%         141.592,140.35,139.13,137.931,136.752,135.593,134.453,133.333,...
%         132.231,131.147,130.081,129.032,128,126.984,125.984,125,124.031,...
%         123.076,122.137,121.212,120.3,119.402,118.518,117.647,116.788,...
%         115.942,115.107,114.285,113.475,112.676,111.888,111.111,110.344,...
%         109.589,108.843,108.108,107.382,106.666,105.96,105.263,104.575,...
%         103.896,103.225,102.564,101.91,101.265,100.628,100,99.378,98.765,...
%         98.159,97.56,96.969,96.385,95.808,95.238,94.674,94.117,93.567,...
%         93.023,92.485,91.954,91.428,90.909,90.395,89.887,89.385,88.888,...
%         88.397,87.912,87.431,86.956,86.486,86.021,85.561,85.106,84.656,...
%         84.21,83.769,83.333,82.901,82.474,82.051,81.632,81.218,80.808,80.402,80.002,79.6];
%
%     period_ary_arduino = fliplr(period_ary_arduino)';
%
% i=1;
%
% %BLUETOOTH!!!
%
% hLine = plot(period_ary,period_freq);
% ylim([0 5])
% %
% % touchit_gui_data = guidata(handles.TouchIT_main);
% % %touchit_gui_data.btt = btt;
% % touchit_gui_data.axesplot = hLine;
% % guidata(handles.TouchIT_main,touchit_gui_data)
% %
% % period_res = randi(4000,1,200)';
% % %set(hLine,'YData',period_res);  %Updaten der Kurve
% % %drawnow %Steuerelement zwingen neu zu zeichnen
% % iN = 2; % Länge des Filters
% % period_res = filter(ones(1,iN)/iN, 1, period_res);
% %
% % set(hLine,'YData',period_res);  %Updaten der Kurve
% % drawnow %Steuerelement zwingen neu zu zeichnen
%
% touchit_gui_data = guidata(handles.TouchIT_main);
% touchit_gui_data.plothline = hLine;
% guidata(touchit_gui_data.TouchIT_main, touchit_gui_data)
%
% touchit_gui_data = guidata(handles.TouchIT_main);


touchit_gui_data = guidata(handles.TouchIT_main);

touchit_gui_data.capture = 1;

guidata(handles.TouchIT_main,touchit_gui_data)




% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


touchit_gui_data = guidata(handles.TouchIT_main);

touchit_gui_data.save = 1;
touchit_gui_data.countsave = 1;

guidata(handles.TouchIT_main,touchit_gui_data)


% --- Executes on button press in pb_touch.
function pb_touch_Callback(hObject, eventdata, handles)
% hObject    handle to pb_touch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
touchit_gui_data = guidata(handles.TouchIT_main);

set(touchit_gui_data.pb_go, 'BackgroundColor', [0.94 0.94 0.94]);

set(touchit_gui_data.txt_nc, 'String', 'NOT CALIBRATED');
set(touchit_gui_data.txt_nc, 'ForegroundColor', 'red');

touchit_gui_data.record = 0;


set(touchit_gui_data.pb_wasserglas, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_door, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_water, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartp, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_metal, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_touch, 'BackgroundColor', 'green');
set(touchit_gui_data.pb_smartkey, 'BackgroundColor', [0.94 0.94 0.94]);




set(touchit_gui_data.pb_notouch, 'String','Keine Berührung');
set(touchit_gui_data.pb_onefinger, 'String','Ein Finger');
set(touchit_gui_data.pb_fivefingers, 'String','Fünf Finger');
set(touchit_gui_data.pb_grasp, 'String','Hände verschränkt');
set(touchit_gui_data.pb_coverears, 'String', 'Hände an Ohren');

guidata(handles.TouchIT_main,touchit_gui_data)


% --- Executes on button press in pb_metal.
function pb_metal_Callback(hObject, eventdata, handles)
% hObject    handle to pb_metal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

touchit_gui_data = guidata(handles.TouchIT_main);

set(touchit_gui_data.pb_go, 'BackgroundColor', [0.94 0.94 0.94]);

set(touchit_gui_data.txt_nc, 'String', 'NOT CALIBRATED');
set(touchit_gui_data.txt_nc, 'ForegroundColor', 'red');

touchit_gui_data.record = 0;


set(touchit_gui_data.pb_wasserglas, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_door, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_water, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartp, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_metal, 'BackgroundColor', 'green');
set(touchit_gui_data.pb_touch, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartkey, 'BackgroundColor', [0.94 0.94 0.94]);


set(touchit_gui_data.pb_notouch, 'String','Ein Arm');
set(touchit_gui_data.pb_onefinger, 'String','Zwei Arme');
set(touchit_gui_data.pb_fivefingers, 'String','Ein Ellenbogen');
set(touchit_gui_data.pb_grasp, 'String','Zwei Ellenbogen');
set(touchit_gui_data.pb_coverears, 'String', 'Arme flach aufliegend');

guidata(handles.TouchIT_main,touchit_gui_data)


% --- Executes on button press in pb_smartkey.
function pb_smartkey_Callback(hObject, eventdata, handles)
% hObject    handle to pb_smartkey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

touchit_gui_data = guidata(handles.TouchIT_main);

set(touchit_gui_data.pb_go, 'BackgroundColor', [0.94 0.94 0.94]);

set(touchit_gui_data.txt_nc, 'String', 'NOT CALIBRATED');
set(touchit_gui_data.txt_nc, 'ForegroundColor', 'red');

touchit_gui_data.record = 0;


set(touchit_gui_data.pb_wasserglas, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_door, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_water, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartp, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_metal, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_touch, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartkey, 'BackgroundColor', 'green');




set(touchit_gui_data.pb_notouch, 'String','Stufe 0');
set(touchit_gui_data.pb_onefinger, 'String','Stufe 1');
set(touchit_gui_data.pb_fivefingers, 'String','Stufe 2');
set(touchit_gui_data.pb_grasp, 'String','Stufe 3');
set(touchit_gui_data.pb_coverears, 'String', 'Stufe 4 - Erfolg');

guidata(handles.TouchIT_main,touchit_gui_data)


% --- Executes on button press in pb_water.
function pb_water_Callback(hObject, eventdata, handles)
% hObject    handle to pb_water (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

touchit_gui_data = guidata(handles.TouchIT_main);

set(touchit_gui_data.pb_go, 'BackgroundColor', [0.94 0.94 0.94]);

set(touchit_gui_data.txt_nc, 'String', 'NOT CALIBRATED');
set(touchit_gui_data.txt_nc, 'ForegroundColor', 'red');

touchit_gui_data.record = 0;


set(touchit_gui_data.pb_wasserglas, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_door, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_water, 'BackgroundColor', 'green');
set(touchit_gui_data.pb_smartp, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_metal, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_touch, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartkey, 'BackgroundColor', [0.94 0.94 0.94]);



set(touchit_gui_data.pb_notouch, 'String','Keine Berührung');
set(touchit_gui_data.pb_onefinger, 'String','Ein Finger eingetaucht');
set(touchit_gui_data.pb_fivefingers, 'String','Drei Finger eingetaucht');
set(touchit_gui_data.pb_grasp, 'String','Ein Finger am Grund');
set(touchit_gui_data.pb_coverears, 'String', 'Handfläche am Grund');

guidata(handles.TouchIT_main,touchit_gui_data)


% --- Executes on button press in pb_door.
function pb_door_Callback(hObject, eventdata, handles)
% hObject    handle to pb_door (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


touchit_gui_data = guidata(handles.TouchIT_main);

set(touchit_gui_data.pb_go, 'BackgroundColor', [0.94 0.94 0.94]);

set(touchit_gui_data.txt_nc, 'String', 'NOT CALIBRATED');
set(touchit_gui_data.txt_nc, 'ForegroundColor', 'red');

touchit_gui_data.record = 0;

set(touchit_gui_data.pb_wasserglas, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_door, 'BackgroundColor', 'green');
set(touchit_gui_data.pb_water, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartp, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_metal, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_touch, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartkey, 'BackgroundColor', [0.94 0.94 0.94]);



set(touchit_gui_data.pb_notouch, 'String','Keine Berührung');
set(touchit_gui_data.pb_onefinger, 'String','Ein Finger');
set(touchit_gui_data.pb_fivefingers, 'String','Zwei Finger');
set(touchit_gui_data.pb_grasp, 'String','Zwei Finger umschloßen');
set(touchit_gui_data.pb_coverears, 'String', 'Umschloßen');

guidata(handles.TouchIT_main,touchit_gui_data)



% --- Executes on button press in pb_filter.
function pb_filter_Callback(hObject, eventdata, handles)
% hObject    handle to pb_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

touchit_gui_data = guidata(handles.TouchIT_main);

switch touchit_gui_data.filter
    
    case 0
        
        touchit_gui_data.filter = 1;
        
        
    case 1
        
        touchit_gui_data.filter = 2;
        
        
    case 2
        
        touchit_gui_data.filter = 0;
        
        
        
end


guidata(handles.TouchIT_main,touchit_gui_data)




% --- Executes on button press in pb_ardu.
function pb_ardu_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ardu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

touchit_gui_data = guidata(handles.TouchIT_main);

if (touchit_gui_data.arduino == 0)
    
    touchit_gui_data.arduino = 1;
    
else
    
    touchit_gui_data.arduino = 0;
    
end

guidata(handles.TouchIT_main,touchit_gui_data)





% --- Executes on button press in pb_wasserglas.
function pb_wasserglas_Callback(hObject, eventdata, handles)
% hObject    handle to pb_wasserglas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

touchit_gui_data = guidata(handles.TouchIT_main);

set(touchit_gui_data.pb_go, 'BackgroundColor', [0.94 0.94 0.94]);

set(touchit_gui_data.pb_wasserglas, 'BackgroundColor', 'green');
set(touchit_gui_data.pb_door, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_water, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartp, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_metal, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_touch, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartkey, 'BackgroundColor', [0.94 0.94 0.94]);



set(touchit_gui_data.txt_nc, 'String', 'NOT CALIBRATED');
set(touchit_gui_data.txt_nc, 'ForegroundColor', 'red');

touchit_gui_data.record = 0;



set(touchit_gui_data.pb_notouch, 'String','Keine Berührung');
set(touchit_gui_data.pb_onefinger, 'String','Ein Finger außen');
set(touchit_gui_data.pb_fivefingers, 'String','Drei Finger außen');
set(touchit_gui_data.pb_grasp, 'String','Ein Finger eingetaucht');
set(touchit_gui_data.pb_coverears, 'String', 'N/A');

guidata(handles.TouchIT_main,touchit_gui_data)


% --- Executes on button press in pb_smartp.
function pb_smartp_Callback(hObject, eventdata, handles)
% hObject    handle to pb_smartp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

touchit_gui_data = guidata(handles.TouchIT_main);

set(touchit_gui_data.pb_go, 'BackgroundColor', [0.94 0.94 0.94]);

set(touchit_gui_data.txt_nc, 'String', 'NOT CALIBRATED');
set(touchit_gui_data.txt_nc, 'ForegroundColor', 'red');

touchit_gui_data.record = 0;

set(touchit_gui_data.pb_wasserglas, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_door, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_water, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartp, 'BackgroundColor', 'green');
set(touchit_gui_data.pb_metal, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_touch, 'BackgroundColor', [0.94 0.94 0.94]);
set(touchit_gui_data.pb_smartkey, 'BackgroundColor', [0.94 0.94 0.94]);



set(touchit_gui_data.pb_notouch, 'String','Keine Berührung');
set(touchit_gui_data.pb_onefinger, 'String','Rechte Hand');
set(touchit_gui_data.pb_fivefingers, 'String','Linke Hand');
set(touchit_gui_data.pb_grasp, 'String','Beidhändig');
set(touchit_gui_data.pb_coverears, 'String', 'N/A');

guidata(handles.TouchIT_main,touchit_gui_data)


% --- Executes on button press in pb_fuenf.
function pb_fuenf_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fuenf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_vier.
function pb_vier_Callback(hObject, eventdata, handles)
% hObject    handle to pb_vier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_drei.
function pb_drei_Callback(hObject, eventdata, handles)
% hObject    handle to pb_drei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_zwei.
function pb_zwei_Callback(hObject, eventdata, handles)
% hObject    handle to pb_zwei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
