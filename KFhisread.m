function img = KFhisread(scatname, imnum, w, frame, boolRotate)

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
%   Created:      July 2015
%   Last Updated: June 2016 by Kelly Foran
%
%
%   INPUT
%
%   file: the .his file to be read in
%   frame: the frame number in which the image is contained
%   boolRotate: if true, image will be rotated counterclockwise by 270 deg
%   tiffname: name of tiff filed saved 
%
%   OUTPUT
%
%   img: the x-ray image
%
%**************************************************************************

f=sprintf('kf%d-%s%d.his',imnum,scatname,w);
A=fullfile('Documents','traajo','carleton','matlab_imagedisp','staircase_deformation_45mm.his');
fid = fopen(A);

if fid == -1
    warning('File could not be opened');
    img = -1;
else
    % Read in entire file
    hisFile= fread(fid,inf,'uint16')';
    
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
    img = uint16(hisFile(start:finish));
    
    % Reshape array into rectangular matrix
    img = reshape(img,dim)';
    
    fclose(fid);
    
    if boolRotate
        img = rot90(img,3);
    end
    tiffname=sprintf('kf%d-%s%d.tif',imnum,scatname,w);
    imwrite(img,tiffname,'tif')
    
end