function varargout = create_survey(varargin)
% CREATE_SURVEY MATLAB code for create_survey.fig
%      CREATE_SURVEY, by itself, creates a new CREATE_SURVEY or raises the existing
%      singleton*.
%
%      H = CREATE_SURVEY returns the handle to a new CREATE_SURVEY or the handle to
%      the existing singleton*.
%
%      CREATE_SURVEY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CREATE_SURVEY.M with the given input arguments.
%
%      CREATE_SURVEY('Property','Value',...) creates a new CREATE_SURVEY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before create_survey_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to create_survey_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help create_survey

% Last Modified by GUIDE v2.5 14-Nov-2010 23:41:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @create_survey_OpeningFcn, ...
                   'gui_OutputFcn',  @create_survey_OutputFcn, ...
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

% --- Executes just before create_survey is made visible.
function create_survey_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to create_survey (see VARARGIN)

% Choose default command line output for create_survey
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using create_survey.
%if strcmp(get(hObject,'Visible'),'off')
%    plot([1 1], [1 1]);
%end
axis(handles.axes4, 'off');

% UIWAIT makes create_survey wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = create_survey_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to open_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.srv');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function save_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to save_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function close_menu_item_Callback(hObject, eventdata, handles)
% hObject    handle to close_menu_item (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --------------------------------------------------------------------
function Import_Callback(hObject, eventdata, handles)
% hObject    handle to Import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function import_sequence_file_Callback(hObject, eventdata, handles)
% hObject    handle to import_sequence_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file path]= uigetfile('*.seq','Select a Sequence File');
if ~isequal(file, 0)
    [survey] = load_sequence([path file]);
    axes(handles.axes1);
    plot_survey(survey);
end

