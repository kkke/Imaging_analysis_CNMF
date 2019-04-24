function varargout = gui2p_Calman3(varargin)
% GUI2P_CALMAN3 MATLAB code for gui2p_Calman3.fig
%      GUI2P_CALMAN3, by itself, creates a new GUI2P_CALMAN3 or raises the existing
%      singleton*.
%
%      H = GUI2P_CALMAN3 returns the handle to a new GUI2P_CALMAN3 or the handle to
%      the existing singleton*.
%
%      GUI2P_CALMAN3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2P_CALMAN3.M with the given input arguments.
%
%      GUI2P_CALMAN3('Property','Value',...) creates a new GUI2P_CALMAN3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2p_Calman3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2p_Calman3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2p_Calman3

% Last Modified by GUIDE v2.5 25-Mar-2019 13:27:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2p_Calman3_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2p_Calman3_OutputFcn, ...
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


% --- Executes just before gui2p_Calman3 is made visible.
function gui2p_Calman3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2p_Calman3 (see VARARGIN)

% Choose default command line output for gui2p_Calman3
% Choose default command line output for gui2p_Calman2
handles.output = hObject;
handles.cc = varargin{1};
handles.Cn = varargin{2};
handles.jsf = varargin{3};
handles.F_dff = varargin{4}

axes(handles.axes1)
imagesc(handles.Cn)
axis image
hold on
for i = 1:size(handles.cc,1)
        plot(handles.cc{i}(1,:),handles.cc{i}(2,:),'Color',[1,0,0])
        text(handles.jsf(i).centroid(2),handles.jsf(i).centroid(1) ,num2str(i),'Color',[0,0,0],'FontSize',10)

end
title('Selected Component')
hold off
handles.reject =[];

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2p_Calman3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2p_Calman3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.output = handles.reject;
varargout{1} = handles.output;
% Update handles structure
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
t = str2double(get(hObject,'String'));
axes(handles.axes2)
plot(handles.F_dff(t,:))
handles.id = t;
% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.reject =[handles.reject, handles.id];
axes(handles.axes3)
imagesc(handles.Cn)
axis image
hold on
for i = 1:length(handles.reject)
        plot(handles.cc{handles.reject(i)}(1,:),handles.cc{handles.reject(i)}(2,:),'Color',[1,0,0])
        text(handles.jsf(handles.reject(i)).centroid(2),handles.jsf(handles.reject(i)).centroid(1) ,num2str(handles.reject(i)),'Color',[0,0,0],'FontSize',16)
end
title('Reject Component')
hold off
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
reject = handles.reject;
save('reject.mat','reject')
