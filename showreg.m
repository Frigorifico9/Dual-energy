function showreg()
%showreg shows the registered points on the image with a cross and the name
%of the registered point next to it.

global regdata regnames
% Read the registration data
numregpoints = readreg;

if numregpoints < 0
    % No registration points available
    msgbox('No registration data available');
    return
end

% Registration points should now be in the global variables regdata and the
% names should be in the global variable regnames
%echo numregpoints
textoffset = 20;

% Add the points and text
for i=1:numregpoints
    text(regdata(i,1), regdata(i,2), '+','HorizontalAlignment','center','color', 'blue');
    text(regdata(i,1) + textoffset, regdata(i,2), regnames(i), 'color', 'blue');
end