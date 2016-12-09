function varargout = level(action)
%
%this function basically changes the level and window of display depending on the
%'action' requested. 
%
%   by       version       updates
%omoussa        0       first version
%

global image_matrix level window window_max window_min input

%'invert' flips the colormap scale, so the white is black and viceversa
if strcmp(action, 'invert')
    %invert every value individually
    image_matrix = 65535 - double(image_matrix); 
    %adjust the display accordingly
    temp = [window_max, window_min];
    window_min = 65535 - temp(1);
    window_max = 65535 - temp(2);
    level      = 65535 - level;
    %window doesn't change
    show;
    
%'auto' automatically adjusts the display so that the grey scale window range 
%is from the minimum pixel value to the maximum pixel value
elseif strcmp(action, 'auto')
    window_min = double(min(min(image_matrix)));
    window_max = double(max(max(image_matrix)));
    level  = (window_min + window_max)/2;
    window = (window_max - window_min);
    show;

%'levelandwin' prompts the user for level and window values
elseif strcmp(action, 'levelandwin')
    %title and text
    title   = 'Input Level and Window';
    prompt  = {'Level:','Window:'};
    %one line text-field per entry
    lines   = 1;
    level  = (window_min + window_max)/2;
    window = (window_max - window_min);
    %current values of level and window are shown in the text-fields in the dialog
    def     = {num2str(level),num2str(window)};
    %dialog to input values of level and window
    %'input' is a vector containing the typed in strings
    input   = inputdlg(prompt,title,lines,def);
    if(~isempty(input))
        level   = str2num(char(input(1)));
        window  = str2num(char(input(2)));
        window_min = level - (window/2);
        window_max = level + (window/2);
        show;
    end

%'minandmax' prompts the user for values of the window range
elseif strcmp(action, 'minandmax')
    %title and text
    title   = 'Input Window Values';
    prompt  = {'Min value of Window:','Max value of Window:'};
    %one line text_field per entry
    lines   = 1;
    %current values of min and max window levels are shown in the text-fields in
    %the dialog
    def     = {num2str(window_min),num2str(window_max)};
    %dialog to input values of the min and max window levels
    %'input' is a vector containing the strings typed in by user
    input   = inputdlg(prompt,title,lines,def);
    if(~isempty(input))
        window_min  = str2num(char(input(1)));
        window_max  = str2num(char(input(2)));
        level  = (window_min + window_max)/2;
        window = (window_max - window_min);
        show;
    end
    
end


%end of file