function varargout = show(varargin)
%
%this function shows the image on the current axis after every display operation
%
%   by       version       updates
%omoussa        0       first version
%

global image_matrix window_min window_max imagehandle

%scale image on window using colormap determined by window and level.
imagehandle = imagesc(image_matrix, [window_min window_max]); colormap(gray); %colorbar

%set the aspect ratio so that the x and y axes have the same scale, and tighten the
%axis box around image
axis image;
colorbar;
%turn on interactive display of pixel properties
%pixval on

%end of file