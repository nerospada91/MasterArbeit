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

% Last Modified by GUIDE v2.5 22-Sep-2013 20:03:06

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
btt = Bluetooth('JY-MCU', 1);
btt.InputBufferSize=1024;
fopen(btt);

set(0,'userdata',1)

period_res = zeros(200,1);

hLine = plot(period_freq, period_res);
ylim([0 4100])

touchit_gui_data = guidata(handles.TouchIT_main);
touchit_gui_data.btt = btt;
touchit_gui_data.axesplot = hLine;
guidata(handles.TouchIT_main,touchit_gui_data)

while 1
    
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
    
    set(hLine,'YData',period_res);  %Updaten der Kurve
    drawnow %Steuerelement zwingen neu zu zeichnen
    
    if get(0,'userdata') == 0
        break
    end
    
    touchit_gui_data = guidata(handles.TouchIT_main);
    if isfield(touchit_gui_data, 'dataU1')
        
        set(handles.pb_user1, 'BackgroundColor', 'green');
        
    end
    
    if isfield(touchit_gui_data, 'dataU2')
        
        set(handles.pb_user2, 'BackgroundColor', 'green');
        
    end
    

    
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
%delete(hObject);


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
