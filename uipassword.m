function pass = uipassword(valid,heading)
%Create password dialogue (hides password input).
% pass = uipassword       -display dialogue
% pass = uipassword(str)    -list of valid characters (default: char(32:126))
% pass = uipassword(str,lbl)  -dialogue heading (default: 'Enter Password')
%
%Remarks:
%-WindowStyle='modal' blocks user interaction with other UI elements.
%
%Example:
% pass = uipassword('0123456789','Enter PIN') 
%
%See also: uilogin, strencrypt

if nargin<1 || isempty(valid), valid = char(32:126); end %default charset
if nargin<2 || isempty(heading), heading = 'Enter password'; end %default heeding

ScreenSize = get(0,'ScreenSize');
hfig  = figure(WindowStyle='modal' ,Units='pixels',Position=[(ScreenSize(3:4)-[300 75])/2 300 75],Name=heading,Resize='off',NumberTitle='off',Menubar='none',Color=[0.9 0.9 0.9],KeyPressFcn=@keypress,CloseRequestFcn=@(~,~)uiresume);
hpass = uicontrol(hfig,Style='text',Units='pixels',Position=[20 30 260 20],FontSize=10,BackGroundColor='w');
hwarn = uicontrol(hfig,Style='text',Units='pixels',Position=[50  2 200 20],FontSize=10,BackGroundColor=[0.9 0.9 0.9]);
pass = ''; %init
uiwait %hold program execution
delete(hfig) %clean up

    function keypress(~,event)
        if event.Key=="backspace"
            pass = pass(1:end-1); %shorten password
        elseif contains(event.Key,{'return' 'escape'}) %Enter or ESC was pressed
            uiresume, return %exit
        elseif event.Key=="shift"
            %do nothing
        elseif contains(event.Character,num2cell(char(valid)))
            pass(end+1) = event.Character; %append key to password
        else
            hwarn.String = 'Invalid character'; %warn user
            pause(0.5);
            hwarn.String = '';
        end
        hpass.String = repmat(char(8226),size(pass)); %display dots instead of password
    end
end