function defreg()
% register allows the user to specify registration points in the image.
% These points will be stored in a separate file and can be used by the
% software later to translate or rotate the image (ie to match it up with
% points from another image)

global path file_name regdata regnames
% Define the file name where the registration information will be stored
% Registration file is the name of the existing file with '.reg' appended
regfile = [path file_name '.reg'];

% Registration loop for each point that the user wants registered.  Each
% point will have the x and y pixel values as well as a name stored
RegFinished = false;
queststring = 'Register another point?';
questtitle = 'Image Registration';
regprompt = 'Enter name for registration point.  When complete select the point';
regtitle = 'Image Registration';
reglines = 1;
%regdata = cell(1,3);
regdata = [];
regnames = [];
numpoints = 0;

while ~RegFinished
    %Get registration information
   regname = inputdlg(regprompt,regtitle,reglines);
   
   %check that cancel button wasn't clicked
   if isempty(regname)
        return
   end
   
   %Get the registration point
   [xreg, yreg] = ginput(1);
   
   %Add to registration table
   %if isempty(regdata)
       %regdata = [xreg, yreg, regname];
   %    regdata{1,1} = xreg;
   %    regdata{1,2} = yreg;
   %    regdata{1,3} = regname;
   %else
       %regdata = [regdata; {xreg, yreg, regname}];
       regdata = [regdata; [xreg, yreg]];
       regnames = [regnames; regname];
       %end
   
    numpoints = numpoints + 1;
    %Ask to register another point
    uresponse = questdlg(queststring, questtitle);
    if strcmp(uresponse,'Yes')
        RegFinished = false;    
    else
        RegFinished = true;
    end
end

regnamesch = char(regnames);
% Output the registration data to the file (overwrites an existing file, if
% it exists)

fid = fopen(regfile,'w');
fprintf(fid,'%s\n', 'xpix ypix name');

% Can't use vectorized form of fprintf because Matlab doesn't like using
% fprintf with cells of mixed data types
for i =1:numpoints
    fprintf(fid,'%8.4f ', regdata(i,1), regdata(i,2));
    fprintf(fid, '%s\n', regnamesch(i,:));
end

fclose(fid)