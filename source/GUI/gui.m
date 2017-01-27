function varargout = gui(varargin)
% gui MATLAB code for gui.fig
%      gui, by itself, creates a new gui or raises the existing
%      singleton*.
%
%      H = gui returns the handle to a new gui or the handle to
%      the existing singleton*.
%
%      gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gui.M with the given input arguments.
%
%      gui('Property','Value',...) creates a new gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%

%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 04-Apr-2014 23:34:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui

% Creating video object and displaying it on GUI axes 
handles.output = hObject;
axes(handles.axes1);
vid=videoinput('winvideo',2,'YUY2_640x480');
hImage=image(zeros(640,480,3),'Parent',handles.axes1);
preview(vid,hImage);

global on_off_flag; % variable for laser on_off control
on_off_flag = 0;    % Initially off
% Creating serial port object
global s;
s = serial('COM6');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.fig_mouse);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse motion over figure - except title and menu.
function fig_mouse_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to fig_mouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pos = get(hObject, 'currentpoint'); % get mouse location on figure
global s;
global x;
global y;

x = pos(1); y = pos(2); % assign locations to x and y


set(handles.lbl_x, 'string', ['x loc:' num2str(x)]); % update text for x loc
set(handles.lbl_y, 'string', ['y loc:' num2str(y)]); % update text for y loc 

% Calculating Base and Shoulder Angles
% flag = strcmp(s.status , 'open'); % returns 1 if both strings are equal
% if flag == 1
% 
% a1 = x/16;
% a1 = round(a1) + 1;
% pulse1 = 1640 + 100 - a1*10;
% pulstr1 = num2str(pulse1);
% fwrite(s,strcat(pulstr1,'b'));
% 
% a2 = y/16;
% a2 = round(a2) + 1;
% pulse2 = 1640 + 200 - a2*10;
% pulstr2 = num2str(pulse2);
% fwrite(s,strcat(pulstr1,'b'));
% fwrite(s,strcat(pulstr2,'s'));
% end

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global s;
fopen(s);   % Opening serial port

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
fclose(s);  % Closing serial port


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function fig_mouse_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to fig_mouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Toggling Laser on each click
global s;
global on_off_flag;
if on_off_flag == 1
    fwrite(s,'OFF');
    on_off_flag = 0;
    
elseif on_off_flag == 0
    fwrite(s,'ON');
    on_off_flag = 1;
end


% --- Executes on key press with focus on fig_mouse and none of its controls.
function fig_mouse_KeyPressFcn(~, eventdata, handles)
% hObject    handle to fig_mouse (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
disp('Switching to frame :');
disp(eventdata.Key)         
global s;
switch eventdata.Key
    case '1'
        fwrite(s,'600f');
    
    case '2'
        fwrite(s,'900f');
      
    case '3'
        fwrite(s,'1300f');

end