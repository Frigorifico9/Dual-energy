function writeimage()
% Writes image_matrix to a file

global image_matrix

% Define the permitted formats to write the image to
fspec = {'*.tif', 'TIFF format';
        '*.dcm', 'DICOM format'};

[fname, pathname, findex] = uiputfile(fspec);

if(fname)
    if(findex == 1)
        fmtstring = 'tif';
    end
    if(findex == 2)
        fmtstring = 'dcm';
    end
    if(findex == 3)
        msgbox('File will be written in TIF format by default');
        fmtstring = 'tif';
    end
    
    fullfilename = [pathname fname];
    if fmtstring == 'dcm'
        dicomwrite(uint16(image_matrix),fullfilename);
    else
        imwrite(uint16(image_matrix),fullfilename);
    end
end