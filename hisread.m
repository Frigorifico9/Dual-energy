function [img,I] = hisread(file, frame, boolRotate)

%*******************************************************************************
%   Read HIS Image
%   hisread.m
%
%   Purpose:      To read an x-ray image HIS file from the PerkinElmer HIS
%                 file format. In XIS, all frames are saved in the HIS
%                 file. Since the desired image is usually only stored in
%                 one of these frames, one can specify the frame in which
%                 the image is contained.
%
%   Author:       Joey Carter
%   Created:      May 8, 2015
%   Last Updated: May 11, 2015
%
%
%   INPUT
%
%   file: the .his file to be read in
%   frame: the frame number in which the image is contained
%   boolRotate: if true, image will be rotated counterclockwise by 90 deg
%
%   OUTPUT
%
%   img: the x-ray image
%
%*******************************************************************************

fid = fopen(file);

if fid == -1
    warning('File could not be opened');
    img = -1;
else

    % Read in the entire .his file
    hisFile = fread(fid, Inf, 'uint16')';
    
    % Parse the header for image dimensions
    header = hisFile(1:50);
    dim = header(9:10);
    
    % Number of pixels in one frame
    nPixel = dim(1)*dim(2);
    
    % Determine number of frames in .his file
    nFrame = (length(hisFile) - length(header)) / nPixel;
    
    if frame > nFrame
        error('There are only %d frames in this file', nFrame)
    end
    
    % Read image from desired frame
    start  = (frame - 1) * nPixel + length(header) + 1;
    finish = start + nPixel - 1;
    img = hisFile(start:finish);
    
    % Reshape array into rectangular matrix
    img = reshape(img,dim)';
    
    fclose(fid);
    
    if boolRotate
        img = rot90(img,3);
    end
    
    I = mat2gray(img);
    imshow(I)
    
end