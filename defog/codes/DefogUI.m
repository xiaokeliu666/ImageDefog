function varargout = DefogUI(varargin)
% DEFOGUI MATLAB code for DefogUI.fig
%      DEFOGUI, by itself, creates a new DEFOGUI or raises the existing
%      singleton*.
%
%      H = DEFOGUI returns the handle to a new DEFOGUI or the handle to
%      the existing singleton*.
%
%      DEFOGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFOGUI.M with the given input arguments.
%
%      DEFOGUI('Property','Value',...) creates a new DEFOGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DefogUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DefogUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DefogUI

% Last Modified by GUIDE v2.5 11-Nov-2018 13:26:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DefogUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DefogUI_OutputFcn, ...
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


% --- Executes just before DefogUI is made visible.
function DefogUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DefogUI (see VARARGIN)

% Choose default command line output for DefogUI
handles.output = hObject;
global img;
global filename;
filename = '07.jpg';
adr = ['Test Images\Fogs\', filename];
img = imread(adr); % Load Image
showOriginalImage(handles);
showDefogImage(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DefogUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DefogUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openButton.
function openButton_Callback(hObject, eventdata, handles)
% hObject    handle to openButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)  
global img;
global filename;
tmp = filename;
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.png'}, 'Open Image', 'Test Images\Fogs\');
if isequal(filename, 0) || isequal(pathname, 0)
    msgbox('Open failed');
    filename = tmp;
else
    adr = [pathname filename];
    img = imread(adr);
    showOriginalImage(handles);
    showDefogImage(handles);
end

% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global J;
global filename;
adr = ['Test Images\Defogs\', filename];
imwrite(uint8(J), adr);
msgbox('Save completed');

% --- Executes on slider movement.
function sliderOmega_Callback(hObject, eventdata, handles)
% hObject    handle to sliderOmega (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
omega = get(handles.sliderOmega, 'value');
set(handles.displayOmega, 'String', roundn(omega, -2));
showDefogImage(handles);

% --- Executes during object creation, after setting all properties.
function sliderOmega_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderOmega (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function sliderMaxA_Callback(hObject, eventdata, handles)
% hObject    handle to sliderMaxA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
maxA = floor(get(handles.sliderMaxA, 'value'));
set(handles.displayMaxA, 'String', maxA);
showDefogImage(handles);


% --- Executes during object creation, after setting all properties.
function sliderMaxA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMaxA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function showOriginalImage(handles)
global img;
axes(handles.originalImg);
imshow(uint8(img));

function showDefogImage(handles)
global img;
global J;
omega = get(handles.sliderOmega, 'value');
maxA = floor(get(handles.sliderMaxA, 'value'));
J = Defog(img, maxA, omega);
axes(handles.defogImg);
imshow(uint8(J));
