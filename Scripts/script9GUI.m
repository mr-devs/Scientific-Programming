function varargout = script9GUI(varargin)
% SCRIPT9GUI MATLAB code for script9GUI.fig
%      SCRIPT9GUI, by itself, creates a new SCRIPT9GUI or raises the existing
%      singleton*.
%
%      H = SCRIPT9GUI returns the handle to a new SCRIPT9GUI or the handle to
%      the existing singleton*.
%
%      SCRIPT9GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCRIPT9GUI.M with the given input arguments.
%
%      SCRIPT9GUI('Property','Value',...) creates a new SCRIPT9GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before script9GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to script9GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help script9GUI

% Last Modified by GUIDE v2.5 03-Jul-2019 19:51:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @script9GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @script9GUI_OutputFcn, ...
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


% --- Executes just before script9GUI is made visible.
function script9GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to script9GUI (see VARARGIN)

% Choose default command line output for script9GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes script9GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = script9GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function inputName_Callback(hObject, eventdata, handles)
% hObject    handle to inputName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputName as text
%        str2double(get(hObject,'String')) returns contents of inputName as a double


% --- Executes during object creation, after setting all properties.
function inputName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sortButton.
function sortButton_Callback(hObject, eventdata, handles)
% hObject    handle to sortButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = get(handles.inputName,'String')
sortedTemp = sort(temp)
set(handles.inputName,'String',sortedTemp)
guidata(hObject, handles);


% --- Executes on button press in gSata.
function gSata_Callback(hObject, eventdata, handles)
% hObject    handle to gSata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = str2num(get(handles.numSata,'String'))

%Get the values of the radiobuttons
radioStatus = [get(handles.radiobutton1,'Value') ...
    get(handles.radiobutton2,'Value')...
    get(handles.radiobutton3,'Value')...
    get(handles.radiobutton4,'Value')]
if radioStatus(1) == 1 %If user wanted a normal distribution
sata = randn(temp,1) %Generate sata
elseif radioStatus(2) == 1 %If user wanted a uniform distribution
sata = rand(temp,1) %Generate sata
elseif radioStatus(3) == 1 %If user wanted a gamma distribution
sata = random('gam',2,2,temp,1) %we hardcoded the parameters as 2 and 2, that's reasonable. But we could read out the sliders. So you can play around
elseif radioStatus(4) == 1 %If user wanted a Weibull distribution
sata = random('wbl',2,2,temp,1)
end
    
handles.sata = sata; %Attach the sata to the handles structure, so that it can be passed around
set(handles.visS,'Visible','On') %Make sata visualization button visible at the right place
set(handles.satMean,'Visible','On')
set(handles.numBins,'Visible','On')
set(handles.fN,'Visible','On')
set(handles.az5,'Visible','On')
guidata(hObject, handles);


% --- Executes on button press in visS.
function visS_Callback(hObject, eventdata, handles)
% hObject    handle to visS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
numBins = str2num(get(handles.numBins,'String'));
set(handles.satVisAx,'Visible','on')
histogram(handles.sata,numBins)
guidata(hObject, handles);


% --- Executes on button press in satMean.
function satMean_Callback(hObject, eventdata, handles)
% hObject    handle to satMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = num2str(mean(handles.sata)) %Compute the mean
set(handles.satMeanOutput,'Visible','On')
set(handles.satMeanOutput,'String',temp)
guidata(hObject, handles);



function numSata_Callback(hObject, eventdata, handles)
% hObject    handle to numSata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numSata as text
%        str2double(get(hObject,'String')) returns contents of numSata as a double


% --- Executes during object creation, after setting all properties.
function numSata_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numSata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numBins_Callback(hObject, eventdata, handles)
% hObject    handle to numBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numBins as text
%        str2double(get(hObject,'String')) returns contents of numBins as a double


% --- Executes during object creation, after setting all properties.
function numBins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in az5.
function az5_Callback(hObject, eventdata, handles)
% hObject    handle to az5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp = get(handles.fN,'String')
save(temp)


function fN_Callback(hObject, eventdata, handles)
% hObject    handle to fN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fN as text
%        str2double(get(hObject,'String')) returns contents of fN as a double


% --- Executes during object creation, after setting all properties.
function fN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
