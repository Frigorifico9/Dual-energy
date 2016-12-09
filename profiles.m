function varargout = profiles(align);
%
%this function caulates and plots a profile along a line segment specified by the 
%user. the argument 'align' specifies the orientation of the profile segment;
% if 'align' = 'vert'  -> vertical profile along a specified column.
% if 'align' = 'horz'  -> horizontal profile along a specified row.
% if 'align' = 'angle' -> in principal, the function could then generate a profile
%                         along a multiline path, but is usually used for one inclined
%                         segment.
%
%   by       version       updates
%omoussa        0       first version
%

global newfig image_matrix image_height image_width

title     = 'Profile Position';

if strcmp(align, 'vert')
    
    pickpoint = ginput(1);
    col_num   = inputdlg({'Column Number'}, title, 1, {num2str(round(pickpoint(1)))});
    xis = [str2num(col_num{1}) str2num(col_num{1})];
    yis = [0 image_height];
    [cx, cy, c] = improfile(image_matrix, xis, yis);
   
    figure;
    fig_name = ['Vertical Profile at Column ' col_num{1}];
    plot(cy, c); 

elseif strcmp(align, 'horz')
    
    pickpoint = ginput(1);
    row_num   = inputdlg({'Row Number'}, title, 1, {num2str(round(pickpoint(2)))});

    xis = [0 image_width];
    yis = [str2num(row_num{1}) str2num(row_num{1})];
    
    [cx, cy, c] = improfile(image_matrix, xis, yis);
   
    figure;
    fig_name = ['Horizontal Profile at Row ' row_num{1}];
    plot(cx, c); 

elseif strcmp(align, 'angle')

    improfile;
    fig_name = 'Profile';
end
    set(get(gca, 'XLabel'), 'String', 'Distance along profile (Pixels)');
    set(get(gca, 'YLabel'), 'String', 'Pixel Intensity');
    set(gcf, 'NumberTitle', 'off', 'Name', fig_name);
   
%end of file 
                     