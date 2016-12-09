function numreg = readreg()
% readreg reads the registration information contained in the .reg file
% associated with the current image and stores the pixel information in the
% regdata array and the names in the regnames cell array.  File name, path
% as well as the arrays are passed through global variables.
% If the file does not exist or can not be read, the function returns -1,
% otherwise returns the number of registration points read

global path file_name regdata regnames

% construct the registration file name
regfilename = [path file_name '.reg'];

% check that the file exists.  If not, return -1 and exit
if ~exist(regfilename)
    numreg = -1;
    return
end

% read the entries into the arrays
try
    [xpix, ypix, name] = textread(regfilename,'%f %f %s\n','headerlines',1);
catch
    %error reading file
    numreg = -1;
    return
end

numreg = size(xpix,1);
regdata = [xpix, ypix];
regnames = cellstr(name);
