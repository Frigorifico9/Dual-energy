function varargout = import1(fmt)
%
%This function imports *.TIF files into MatLAB 
%can be used to import other formats, but needs little modification (generalization)
%
%   by       version       updates
%omoussa        0       first version
%bking          1       added global filename info for other functions
%

global image_matrix image_height image_width
global level window window_min window_max
global path file_name

%Specific instructions for importing file types here
cancelflag = false;
if(strcmp(fmt,'tif'))
    
    %open an "open file" dialogue and get the filename and path
    [file_name, path] = uigetfile(['*.' fmt], 'Open TIF Image');
    if(~file_name)
        cancelflag = true;
    else
        %read the file (using the filename and path) into a uint16 matrix
        image_matrix = imread([path file_name]);
    end

end

if(strcmp(fmt,'dcm'))
    %open an "open file" dialogue and get the filename and path
    [file_name, path] = uigetfile(['*.' fmt], 'Open Dicom Image');
    
    if(~file_name)
        cancelflag = true;
    else
        %read the file
        image_matrix = dicomread([path file_name]);
    end
end

if(strcmp(fmt,'his'))
    %open an "open file" dialogue and get the filename and path
    dir = 'C:\Users\Xray\MyFiles\JCarter\Summer2015\Programs\Images\';
    [file_name, path] = uigetfile([dir '*.' fmt], 'Open HIS Image');
    
    if(~file_name)
        cancelflag = true;
    else
        %read the file
        frameNum = str2double(inputdlg('Frame Number in HIS File', ...
            'Frame Number', 1, {num2str(2)}));
        image_matrix = hisread([path file_name], frameNum, true);
    end
end

if(strcmp(fmt,'matrix'))
    %open an "open file" dialogue and get the filename and path
    %dir = 'C:\Users\Xray\MyFiles\JCarter\Summer2015\Programs\Images\';
   [file_name, path] = uigetfile(['*.' fmt], 'Open matrix');
    
    if(~file_name)
        cancelflag = true;
    else
        %read the file
        load(file_name,'p_A')
        image_matrix = p_A;
    end
end

if(~cancelflag)
    %set the title of the figure to read the filename
    set(gcf, 'NumberTitle', 'off', 'Name', file_name)

    %set global variables
    image_height = size(image_matrix, 1);
    image_width  = size(image_matrix, 2);

    window_min = 0;
    window_max = 65535;
    

    %show the image on the figure
    show;
    %autocontrast was written as a callback function, thus requires 2
    %currently empty variables at the beginning (not used in this context)
    autocontrast([],[],gcf,2);
    
%     window_min = min(min(image_matrix));
%     window_max = max(max(image_matrix));
%     level  = (window_min + window_max)/2;
%     window = (window_max - window_min);
end
%end of file