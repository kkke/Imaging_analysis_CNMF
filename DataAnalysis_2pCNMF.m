function varargout = DataAnalysis_2pCNMF(varargin)
% DATAANALYSIS_2PCNMF MATLAB code for DataAnalysis_2pCNMF.fig
%      DATAANALYSIS_2PCNMF, by itself, creates a new DATAANALYSIS_2PCNMF or raises the existing
%      singleton*.
%
%      H = DATAANALYSIS_2PCNMF returns the handle to a new DATAANALYSIS_2PCNMF or the handle to
%      the existing singleton*.
%
%      DATAANALYSIS_2PCNMF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAANALYSIS_2PCNMF.M with the given input arguments.
%
%      DATAANALYSIS_2PCNMF('Property','Value',...) creates a new DATAANALYSIS_2PCNMF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataAnalysis_2pCNMF_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataAnalysis_2pCNMF_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataAnalysis_2pCNMF

% Last Modified by GUIDE v2.5 21-Aug-2019 11:34:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DataAnalysis_2pCNMF_OpeningFcn, ...
                   'gui_OutputFcn',  @DataAnalysis_2pCNMF_OutputFcn, ...
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


% --- Executes just before DataAnalysis_2pCNMF is made visible.
function DataAnalysis_2pCNMF_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataAnalysis_2pCNMF (see VARARGIN)

% Choose default command line output for DataAnalysis_2pCNMF
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DataAnalysis_2pCNMF wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DataAnalysis_2pCNMF_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in summarysession.
function summarysession_Callback(hObject, eventdata, handles)
% hObject    handle to summarysession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% choosing the files to load:
msgbox('Please choose the files used to summarize the data:dataForCNMF')
pause(3)
[file_names,files_path]=uigetfile('dataForC*.mat');
animalID = files_path(end-16:end-10);
date     = files_path(end-8:end-3);
set(handles.info,'String',[animalID,'/',date])
summary_forSingleSession(files_path,file_names)

% --- Executes during object creation, after setting all properties.
function info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
