function params = displayParams% For Scanner UMC 7T scanner 1024x768 resolution% 09/2005 SOD: used for front (feet) projector in 3T UMC  scanner.% 26/05/2009 BMH: Modified for UMC 7T scanner% 28/05/2009 BMH: Modified for UMC 7T scanner projector at 1024x768 resolution% Critical parametersparams.numPixels = [800 900];%Old projector setupparams.dimensions = [135 151.9];%Normal%params.Rect = [243 230 781 768]; %params.Rect = [256 256 768 768];%Good for recording movies at 512x512 pixels [256 256 768 768];%params.Rect = [0 0 1024 768];%NORMAL USE THIS%params.Rect = [526 0 1074 548];%params.Rect = [256 0 768 512];%params.Rect=params.Rect(:);params.viewableRect = [0 0 800 468];%[800+233 0 800-233 468];%%params.viewableRect = [100 200 900 668];if exist('/Users/lab/Documents/MATLAB/ScannerStimulus/Displays/7T_DLP_1600x900/screenRotation.mat','file')    disp('Loading previous screen rotation from: /Users/lab/Documents/MATLAB/ScannerStimulus/Displays/7T_DLP_1600x900/screenRotation.mat');    load('screenRotation.mat');    params.screenRotation = screenRotation;    params.horizontalOffset = horizontalOffset;else    disp('No previous screen rotation value found');    params.screenRotation=0;    params.horizontalOffset = 0;endparams.distance = [355]; %[28] %position 3,3    %[35.5]%position 2,3  %[41] %position 1,1 params.frameRate = 60;params.cmapDepth = 8;params.screenNumber = 1;% Descriptive parametersparams.computerName = 'legolas';params.monitor = 'projector';params.card = 'ATI Mobility Radeon 9700';params.position = '7T UMC scanner rear-to-front';     