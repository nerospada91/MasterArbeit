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

% Last Modified by GUIDE v2.5 10-Nov-2013 00:40:29
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

prescale_ary=ones(200,1);
period_ary = [21000,10500,7000,5250,4200,3500,3000,2625,2333,2100,1909,1750,1615,1500,1400,1313,1235,1167,1105,1050,1000,955,913,875,840,808,778,750,724,700,677,656,636,618,600,583,568,553,538,525,512,500,488,477,467,457,447,438,429,420,412,404,396,389,382,375,368,362,356,350,344,339,333,328,323,318,313,309,304,300,296,292,288,284,280,276,273,269,266,263,259,256,253,250,247,244,241,239,236,233,231,228,226,223,221,219,216,214,212,210,208,206,204,202,200,198,196,194,193,191,189,188,186,184,183,181,179,178,176,175,174,172,171,169,168,167,165,164,163,162,160,159,158,157,156,154,153,152,151,150,149,148,147,146,145,144,143,142,141,140,139,138,137,136,135,133,131,130,128,127,125,124,122,121,119,118,117,115,114,113,112,111,109,108,107,106,105,104,103,102,101,100,99,98,97,96,95,95,94,93,92,91,90,89,88,88,87,86,85,84]';
period_freq = ones(200,1)*21;

period_freq = (period_freq ./ prescale_ary ./ period_ary)*1000;

i=1;

%BLUETOOTH!!!
btt = Bluetooth('TOUCHEE', 1);
btt.InputBufferSize=5000000;
fopen(btt);

set(0,'userdata',1)

period_res = zeros(200,1);

hLine = plot(period_freq, period_res);
ylim([0 2])
xlim([1, 250])

touchit_gui_data = guidata(handles.TouchIT_main);
touchit_gui_data.btt = btt;
touchit_gui_data.axesplot = hLine;
touchit_gui_data.record = 0;
guidata(handles.TouchIT_main,touchit_gui_data)
firstshot = 1;


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

%     period_resb = filter(ones(1,iN)/iN, 1, period_res, final_cond1);

    period_resb = period_res;

    if (firstshot == 1)
        
        period_volt = period_resb*0.0012;
        
        firstshot = 0;
        
    else
        
        period_volt = get(hLine,'YData')*0.5 + ((period_resb*0.0012)*0.5)';
        
    end
    
    
   iN = 10; % L�nge des Filters
   [period_volt]  = filter(ones(1,iN)/iN, 1, period_volt);


    set(hLine,'YData',period_volt);  %Updaten der Kurve
    drawnow %Steuerelement zwingen neu zu zeichnen
    
    if get(0,'userdata') == 0
        break
    end
    
    touchit_gui_data = guidata(handles.TouchIT_main);
    
    if isfield(touchit_gui_data, 'dataU1')
        
        fact =  corr(touchit_gui_data.dataU1', period_resb);
        
        if fact > 0.75
            set(handles.pb_user1, 'BackgroundColor', 'green');
        else
            set(handles.pb_user1, 'BackgroundColor', [0.94 0.94 0.94]);
        end
        
        
    end
    
    if isfield(touchit_gui_data, 'dataU2')
        
        fact =  corr(touchit_gui_data.dataU2', period_resb);
        
        if fact > 0.75
            set(handles.pb_user2, 'BackgroundColor', 'green');
        else
            set(handles.pb_user2, 'BackgroundColor', [0.94 0.94 0.94]);
        end
        
    end
    
    
    if (touchit_gui_data.record == 1)
        
        record_rawdata(period_volt);
        
    end
    
    if     strcmp(get(touchit_gui_data.txt_nc, 'String'), 'RUNNING')      
        
        %  k = svmclassify(touchit_gui_data.model1, period_volt);
        
        
        %ist notouch   one finger
        aa = svmclassify(touchit_gui_data.model1, period_volt);

        %ist notouch   five fingers
        bb = svmclassify(touchit_gui_data.model2, period_volt);

        %ist one finger five fingers
        cc = svmclassify(touchit_gui_data.model3, period_volt);
                %ist notouch   one finger
        dd = svmclassify(touchit_gui_data.model4, period_volt);

        %ist notouch   five fingers
        ee = svmclassify(touchit_gui_data.model5, period_volt);

        %ist one finger five fingers
        ff = svmclassify(touchit_gui_data.model6, period_volt);
        
                %ist notouch   one finger
        gg = svmclassify(touchit_gui_data.model7, period_volt);

        %ist notouch   five fingers
        hh = svmclassify(touchit_gui_data.model8, period_volt);

        %ist one finger five fingers
        ii = svmclassify(touchit_gui_data.model9, period_volt);
        
                %ist notouch   one finger
        jj = svmclassify(touchit_gui_data.model10, period_volt);


        C =  countmember([1 2 3 4 5],[aa bb cc dd ee ff gg hh ii jj]);
        [~, h]= max(C);
        
        
        k = [1 2 3 4 5];
        k = k(h);

        switch k
            case 1
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', 'green');
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            case 2
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor','green');
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
            case 3
                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor','green');
                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
                            case 4
                                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                                set(touchit_gui_data.pb_grasp, 'BackgroundColor', 'green');
                                set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
                            case 5
                                set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
                                set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
                                set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
                                set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
                                set(touchit_gui_data.pb_coverears, 'BackgroundColor', 'green');
        end
        
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


% --- Executes on button press in pb_user1.
function pb_user1_Callback(hObject, eventdata, handles)
% hObject    handle to pb_user1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
touchit_gui_data = guidata(handles.TouchIT_main);

touchit_gui_data.dataU1 = get(touchit_gui_data.axesplot, 'YData');

guidata(handles.TouchIT_main,touchit_gui_data)


% --- Executes on button press in pb_user2.
function pb_user2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_user2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

touchit_gui_data = guidata(handles.TouchIT_main);

touchit_gui_data.dataU2 = get(touchit_gui_data.axesplot, 'YData');

guidata(handles.TouchIT_main,touchit_gui_data)


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

nrm_values = 59;

touchit_gui_data = guidata(handles.TouchIT_main);
%touchit_gui_data.record = 0;

if (touchit_gui_data.timer == 1)
    touchit_gui_data.record = 1;
    set(touchit_gui_data.pb_notouch, 'BackgroundColor', 'green');
end

if (touchit_gui_data.timer == 2)
    touchit_gui_data.notouch = rec_dat(end-nrm_values:end,:);
    rec_dat = [];
    set(touchit_gui_data.pb_notouch, 'BackgroundColor', [0.94 0.94 0.94]);
    set(touchit_gui_data.pb_onefinger, 'BackgroundColor', 'green');
end

if (touchit_gui_data.timer == 3)
    touchit_gui_data.onefinger = rec_dat(end-nrm_values:end,:);
    rec_dat = [];
    set(touchit_gui_data.pb_onefinger, 'BackgroundColor', [0.94 0.94 0.94]);
    set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', 'green');
end

if (touchit_gui_data.timer == 4)
    touchit_gui_data.fivefingers = rec_dat(end-nrm_values:end,:);
    rec_dat = [];
    set(touchit_gui_data.pb_fivefingers, 'BackgroundColor', [0.94 0.94 0.94]);
    set(touchit_gui_data.pb_grasp, 'BackgroundColor', 'green');
end

if (touchit_gui_data.timer == 5)
    touchit_gui_data.grasp = rec_dat(end-nrm_values:end,:);
    rec_dat = [];
    set(touchit_gui_data.pb_grasp, 'BackgroundColor', [0.94 0.94 0.94]);
    set(touchit_gui_data.pb_coverears, 'BackgroundColor', 'green');
end

if (touchit_gui_data.timer == 6)
    touchit_gui_data.coverears = rec_dat(end-nrm_values:end,:);
    touchit_gui_data.record = 0;
    rec_dat = [];
    set(touchit_gui_data.pb_coverears, 'BackgroundColor', [0.94 0.94 0.94]);
    stop(touchit_gui_data.tmr);
    delete(touchit_gui_data.tmr);
    touchit_gui_data = train_svm(touchit_gui_data, nrm_values);
    set(touchit_gui_data.txt_nc, 'String', 'CALIBRATED');
    set(touchit_gui_data.txt_nc, 'ForegroundColor', 'green');
end


touchit_gui_data.timer = touchit_gui_data.timer +1;
guidata(handles.TouchIT_main,touchit_gui_data);

function [touchit_gui_data] = train_svm(touchit_gui_data, nrm_values)

% 1 2 3 4 5
s_data = [touchit_gui_data.notouch; touchit_gui_data.onefinger];
s_class = ones(40,1);
s_class(1:nrm_values+1) = 1;
s_class(nrm_values+2:nrm_values*2+2) = 2;
%notouch vs onefinger
SVMstruct1 = svmtrain(s_data,s_class);

s_data = [touchit_gui_data.fivefingers; touchit_gui_data.notouch];
s_class(1:nrm_values+1) = 3;
s_class(nrm_values+2:nrm_values*2+2) = 1;
SVMstruct2 = svmtrain(s_data,s_class);
% 
s_data = [touchit_gui_data.fivefingers; touchit_gui_data.onefinger];
s_class(1:nrm_values+1) = 3;
s_class(nrm_values+2:nrm_values*2+2) = 2;
SVMstruct3 = svmtrain(s_data,s_class);


s_data = [touchit_gui_data.grasp; touchit_gui_data.notouch];
s_class(1:nrm_values+1) = 4;
s_class(nrm_values+2:nrm_values*2+2) = 1;
SVMstruct4 = svmtrain(s_data,s_class);

s_data = [touchit_gui_data.grasp; touchit_gui_data.onefinger];
s_class(1:nrm_values+1) = 4;
s_class(nrm_values+2:nrm_values*2+2) = 2;
SVMstruct5 = svmtrain(s_data,s_class);

s_data = [touchit_gui_data.grasp; touchit_gui_data.fivefingers];
s_class(1:nrm_values+1) = 4;
s_class(nrm_values+2:nrm_values*2+2) = 3;
SVMstruct6 = svmtrain(s_data,s_class);


s_data = [touchit_gui_data.coverears; touchit_gui_data.notouch];
s_class(1:nrm_values+1) = 5;
s_class(nrm_values+2:nrm_values*2+2) = 1;
SVMstruct7 = svmtrain(s_data,s_class);

s_data = [touchit_gui_data.coverears; touchit_gui_data.onefinger];
s_class(1:nrm_values+1) = 5;
s_class(nrm_values+2:nrm_values*2+2) = 2;
SVMstruct8 = svmtrain(s_data,s_class);

s_data = [touchit_gui_data.coverears; touchit_gui_data.fivefingers];
s_class(1:nrm_values+1) = 5;
s_class(nrm_values+2:nrm_values*2+2) = 3;
SVMstruct9 = svmtrain(s_data,s_class);

s_data = [touchit_gui_data.coverears; touchit_gui_data.grasp];
s_class(1:nrm_values+1) = 5;
s_class(nrm_values+2:nrm_values*2+2) = 4;
SVMstruct10 = svmtrain(s_data,s_class);


touchit_gui_data.model1 = SVMstruct1;
touchit_gui_data.model2 = SVMstruct2;
touchit_gui_data.model3 = SVMstruct3;
touchit_gui_data.model4 = SVMstruct4;
touchit_gui_data.model5 = SVMstruct5;
touchit_gui_data.model6 = SVMstruct6;
touchit_gui_data.model7 = SVMstruct7;
touchit_gui_data.model8 = SVMstruct8;
touchit_gui_data.model9 = SVMstruct9;
touchit_gui_data.model10 = SVMstruct10;

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

touchit_gui_data = guidata(handles.TouchIT_main);

prescale_ary=ones(200,1);
period_ary = [21000,10500,7000,5250,4200,3500,3000,2625,2333,2100,1909,1750,1615,1500,1400,1313,1235,1167,1105,1050,1000,955,913,875,840,808,778,750,724,700,677,656,636,618,600,583,568,553,538,525,512,500,488,477,467,457,447,438,429,420,412,404,396,389,382,375,368,362,356,350,344,339,333,328,323,318,313,309,304,300,296,292,288,284,280,276,273,269,266,263,259,256,253,250,247,244,241,239,236,233,231,228,226,223,221,219,216,214,212,210,208,206,204,202,200,198,196,194,193,191,189,188,186,184,183,181,179,178,176,175,174,172,171,169,168,167,165,164,163,162,160,159,158,157,156,154,153,152,151,150,149,148,147,146,145,144,143,142,141,140,139,138,137,136,135,133,131,130,128,127,125,124,122,121,119,118,117,115,114,113,112,111,109,108,107,106,105,104,103,102,101,100,99,98,97,96,95,95,94,93,92,91,90,89,88,88,87,86,85,84]';
period_freq = ones(200,1)*21;

period_freq = (period_freq ./ prescale_ary ./ period_ary)*1000;

i=1;

%BLUETOOTH!!!
    period_res = zeros(200,1);
hLine = plot(period_freq, period_res);
ylim([0 4100])

touchit_gui_data = guidata(handles.TouchIT_main);
%touchit_gui_data.btt = btt;
touchit_gui_data.axesplot = hLine;
guidata(handles.TouchIT_main,touchit_gui_data)

period_res = randi(4000,1,200)';
%set(hLine,'YData',period_res);  %Updaten der Kurve
%drawnow %Steuerelement zwingen neu zu zeichnen
iN = 2; % L�nge des Filters
period_res = filter(ones(1,iN)/iN, 1, period_res);

set(hLine,'YData',period_res);  %Updaten der Kurve
drawnow %Steuerelement zwingen neu zu zeichnen

    touchit_gui_data = guidata(handles.TouchIT_main);
    touchit_gui_data.plothline = hLine;
    guidata(touchit_gui_data.TouchIT_main, touchit_gui_data)

touchit_gui_data = guidata(handles.TouchIT_main);

function C = countmember(A,B)

%   Examples:
%     countmember([1 2 1 3],[1 2 2 2 2]) 
%        -> 1     4     1     0
%     countmember({'a','b','c'},{'a','x','a'}) 
%        -> 2     0     0
%

error(nargchk(2,2,nargin)) ;

if ~isequal(class(A),class(B)),
    error('Both inputs should be the same class.') ;
end
if isempty(B),
    C = zeros(size(A)) ;
    return
elseif isempty(A),
    C = [] ;
    return
end

% which elements are unique in A, 
% also store the position to re-order later on
[AU,j,j] = unique(A(:)) ; 
% assign each element in B a number corresponding to the element of A
[L, L] = ismember(B,AU) ; 
% count these numbers
N = histc(L(:),1:length(AU)) ;
% re-order according to A, and reshape
C = reshape(N(j),size(A)) ;    

