function varargout = GUI_RAINFALL(varargin)
% GUI_RAINFALL MATLAB code for GUI_RAINFALL.fig
%      GUI_RAINFALL, by itself, creates a new GUI_RAINFALL or raises the existing
%      singleton*.
%
%      H = GUI_RAINFALL returns the handle to a new GUI_RAINFALL or the handle to
%      the existing singleton*.
%
%      GUI_RAINFALL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RAINFALL.M with the given input arguments.
%
%      GUI_RAINFALL('Property','Value',...) creates a new GUI_RAINFALL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_RAINFALL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_RAINFALL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_RAINFALL

% Last Modified by GUIDE v2.5 26-Jun-2019 05:44:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_RAINFALL_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_RAINFALL_OutputFcn, ...
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


% --- Executes just before GUI_RAINFALL is made visible.
function GUI_RAINFALL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_RAINFALL (see VARARGIN)

% Choose default command line output for GUI_RAINFALL
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_RAINFALL wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_RAINFALL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c
[filename filepath]=uigetfile('.csv','.xlsx','.mat');
 c = strcat(filepath,filename)
 
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c
c= xlsread(c);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c
global nor
[m,n]=size(c);
for i=1:m
    for j=1:n
        
        a(i,j)=c(i,j);
        M=max(a);
        N= min(a);
        nor(i,j) = (a(i,j) - M) / ( M - N);
        nor(i,j)= abs(nor(i,j));
        if nor(i,j)<10||nor(i,j)>1
            
     nor(i,j)=abs(rdivide(nor(i,j),10));
 elseif nor(i,j)>50||nor(i,j)<10
      nor(i,j)=abs(rdivide(nor(i,j),1000));
 else
     nor(i,j)=abs(rdivide(nor(i,j),100));
 end
    end
       end
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global c
load c.mat
[m n]=size(c);
input=c(114,2:11);
disp(input);
target=c(116,2:11);
disp(target);

[I N] = size(input);
[O N] = size(target);

H = 24
%[input,target] = simplefit_dataset;
net =newff(minmax(input),[H,O],{'tansig' 'purelin'},'trainlm');
net.trainParam.epochs=3000;
net.trainParam.lr=0.3;
net.trainParam.goal=25;
net.trainParam.mc=0.6;
%plotfit(net,input,target);
net = train(net,input,target);
predicted_output=sim(net,input)
errors = gsubtract(target,predicted_output);
%fprintf('Predicted Output = %2.4f , Error deviation = %2.4f\n', output , errors);
performance = perform(net,target,predicted_output);
%disp(performance)

%figure(3)
%h = plot(target , input , 'k' , target , predicted_output , 'r' , 'linewidth' , 2);
%grid on
%axis([100 , 1000 , 0 , 1000])
%xlabel('actual' , 'fontsize' , 11);
%ylabel('data' , 'fontsize' , 11);
%legend(h , 'actual' , 'predicted' , 'location' , 'southeast');


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
global c
load c.mat
[m n]=size(c)
input=c(110:114,2:11);
disp(input);
target=c(116,2:11);
disp(target);


% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created 23-Jun-2019 04:38:02
%
% This script assumes these variables are defined:
%
%   input - input data.
%   target - target data.

x = input;
t = target;

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Create a Fitting Network
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize,trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
% See the help for each generation function for more information.
if (false)
    % Generate MATLAB function for neural network for application
    % deployment in MATLAB scripts or with MATLAB Compiler and Builder
    % tools, or simply to examine the calculations your trained neural
    % network performs.
    genFunction(net,'myNeuralNetworkFunction');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
    y = myNeuralNetworkFunction(x);
end
if (false)
    % Generate a Simulink diagram for simulation or deployment with.
    % Simulink Coder tools.
    gensim(net);
end

