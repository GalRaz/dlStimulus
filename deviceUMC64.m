function [output t0 params] = deviceUMC64(command,params)
% deviceUMC - read UMC scanner trigger and subject response box
%
% output = deviceUMC(command)
%
% commands: 'open'  - opens the communication line
%           'check' - open, report on and close all available ports
%                     useful for finding your device port
%           'read'  - read all that came in (and flush)
%                     output = read, t0 = time of reading.
%           'trigger' - binary output whether trigger occurred (flush
%                       everything else)
%                       output = boolean, t0 = time of trigger.
%           'wait for trigger' - wait untill trigger is recieved before
%                                continuing
%           'button' - buttons that were pushed (all, triggers are flushed)
%                      output = buttons, t0 = time of reading.
%                      (idem: 'response')
%           'close'  - close the communication line
% port:     device port to be checked (see /dev/cu.*)
%           A negative device port does not check serial device but will
%           check the internal keyboard instead. This is useful for the
%           avoiding the command 'wait for trigger' and 'response' etc, 
%           during testing of the stimulus without the serial device.
%
% Device button-to-number configuration:
%     [65]
% [66]    [67]
%     [68]
%      |
%      |
%      V
%     wire
%
% MR trigger = 49
%
% 2009/05 SOD: wrote it as a wrapper for the UMC device using comm.m serial
%              port interface by Tom Davis (http://www.mathworks.com/matlabcentral/fileexchange/4952).
% 2009/11 BMH & SOD: rewrote wrapper for intel mac, using Tom Davis' other
%              function, SerialComm, which is now integrated into matlab.
%              Commands for SerialComm are the same as for comm.
%              Inserted switch for intel macs to choose the right port (2)
%              or port 3 for G4 macs

% default
% if ~exist('port','var') || isempty(port)
%     if strcmp(computer('arch'), 'maci')
%         port = 2; % for macbook pro
%     else
%         port =3; % for G4 powerbook
%     end
% end

% for testing and debugging without UMC device (needs psychtoolbox)
if isempty(params.devices.handle)
    [output t0]=keyboardCheck(command);
    return
end

% parameters
id.device = params.devices.UMCport;
id.trigger = 49;
id.response = 65:68;

% initiate output
output = [];
t0 = [];
params.devices.handle = [];

% execute command
switch(lower(command))
%     case {'check'} % useful for finding your device id/port
%         ndevices = dir('/dev/cu.*');
%         for n=1:numel(ndevices)
%             fprintf(1,'[%s]:Probing device %d: ',mfilename,n);
%             try,
%                 deviceUMC('open',n);
%                 deviceUMC('close',n);
%             catch
%                 %
%             end
%         end

    case {'flush'}
        IOPort('Flush',params.devices.handle);

    case {'open','start'}
        IOPort('CloseAll');
        fprintf(1,'[%s]:Opening device %d: ',mfilename,id.device);
        %SerialComm('open',id.device,'9600,n,8,1');
        params.devices.handle = IOPort('OpenSerialPort',id.device,'9600,n,8,1');

    case {'read'}
        %output = SerialComm('read',id.device);%
        output = IOPort('read',params.devices.handle);%

    case {'trigger'}
        %t = SerialComm('read',id.device);%IOPort('read',id.device);%
        t = IOPort('read',params.devices.handle);
        if ~isempty(t) & any(t==id.trigger)
            output = true;
        end

    case {'waitfortrigger','wait for trigger'}
        % load mex file for more accuracy
        GetSecs;
        % keep checking for trigger while also releasing some CPU
        while(1)
            %t = SerialComm('read',id.device);%IOPort('read',id.device);%
            t = IOPort('read',params.devices.handle);
            

%             if ~isempty(t) & any(t~=id.trigger)
%                 t = t(t~=id.trigger);
%                 output = t;
%                 [exKeyIsDown,exSecs,exKeyCode] = KbCheck(display.devices.keyInputInternal);
%                 if output==66 || exKeyCode(KbName('z'))
%                     display.screenRotation=display.screenRotation+0.1;
%                 elseif output==67 || exKeyCode(KbName('x'))
%                     display.screenRotation=display.screenRotation-0.1;
%                 end
%                 
%                 for ii = 0:display.stereoFlag
%                     Screen('SelectStereoDrawBuffer', display.windowPtr, ii);
%                     Screen('DrawTexture', display.windowPtr, stimulus(1).textures(1), ...
%                         stimulus(1).srcRect, stimulus(1).destRect,2*(ii-.5)*display.screenRotation);
%                     drawFixation(display,stimulus.fixSeq(frame));
%                 end
%                 
%                 
%                 Screen('Flip',display.windowPtr);
%                 
%                 % give some time back to OS
%                 WaitSecs(0.01);
            if ~isempty(t) & any(t==id.trigger)
                output = true;
                t0 = GetSecs;
                break;
            end
        end

    case {'button','response','responses'}
        % everything that is not a trigger
        %t = SerialComm('read',id.device);%IOPort('read',id.device);%
        t = IOPort('read',params.devices.handle);
        if ~isempty(t)
            %t = t(t==id.response(1) | t==id.response(2) | t==id.response(3) | t==id.response(4));
            t = t(t~=id.trigger);
            output = t;
            t0 = GetSecs;
        end

    case {'close'}
        fprintf(1,'[%s]:Closing device %d.\n',mfilename,id.device);
        %SerialComm('close',id.device);%
        %IOPort('close',id.device);
        IOPort('CloseAll');
        

    otherwise
        error('[%s]:Unknown command %s',mfilename,lower(command));
end

if isempty(output),
    output = false;
end

return
%------------------------------------------

%------------------------------------------
function [output t0]=keyboardCheck(command)
% simulate device output

switch(lower(command))
    case {'read','trigger','button','response','responses'}
        [output t0] = KbCheck;

    case {'waitfortrigger','wait for trigger'}
        while(1)
            [output t0] = KbCheck;
            if output
                break;
            else
                % give some time back to OS
                WaitSecs(0.01);
            end
        end

    otherwise
        output = [];
        t0 = [];
        % do nothing

end

return
%------------------------------------------


