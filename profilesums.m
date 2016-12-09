function varargout = profilesums(align);
%
%this function sums each vertical or horizontal profile and plots a profile of those line sums. the argument 'align' specifies the orientation of the profile segment;
% if 'align' = 'vert'  -> profile of the summation of pixel values along a specified set of rows (added up over a certain width bounded by specified columns).
% if 'align' = 'horz'  -> profile of the summation of pixel values along a
% specified set of columns (added up over a certain height bounded by
% specified rows).
% 
%
%   by       version       updates
%kforan        0       first version
%

global newfig image_matrix image_height image_width

title     = 'Summation Area';

if strcmp(align, 'vert')
    h = msgbox('Specify rows for profile by clicking just above the top of the desired area and then clicking just below the bottom of the desired area', 'Rows of Interest', 'modal');
    waitfor(h);
    [pickx,picky] = ginput(2);
    row_num   = inputdlg({'Profile from Row','to Row'}, title, 1, {num2str(round(picky(1))),num2str(round(picky(2)))});
    k = msgbox('Specify pixels to sum over in each row by choosing the left limit and then the right limit', 'Length of Summation', 'modal');
    waitfor(k);
    pickpoint = ginput(2);
    col_num   = inputdlg({'Sum from Column','to Column'}, title, 1, {num2str(round(pickpoint(1))),num2str(round(pickpoint(2)))});
    profheight= str2num(row_num{2}) - str2num(row_num{1})+ 1;
    B = zeros(1,profheight);
    A = zeros(1,profheight);
    xis = [str2num(col_num{1}) (str2num(col_num{2})+30)];
    for a = str2num(row_num{1}):str2num(row_num{2})
        yis = [a a];
        C = improfile(image_matrix, xis, yis);
        B(a) = sum(C);
        A(a) = a;
    end
        
    figure;
    fig_name = ['Summation Profile of Rows ' row_num{1} '-' row_num{2} ' between Columns ' col_num{1} '-' col_num{2}];
    plot(A,B); 

elseif strcmp(align, 'horz')
    h = msgbox('Specify columns for profile by clicking just before the left side of the desired area and then clicking just past the right side of the desired area', 'Columns of Interest', 'modal');
    waitfor(h);
    pickpoint = ginput(2);
    col_num   = inputdlg({'Profile from Column','to Column'}, title, 1, {num2str(round(pickpoint(1))),num2str(round(pickpoint(2)))});
    k = msgbox('Specify pixels to sum over in each column by choosing the upper limiting row (the top of interested area) and then the lower limiting row (the bottom of interested area)', 'Length of Summation', 'modal');
    waitfor(k);
    [pickx,picky] = ginput(2);
    row_num   = inputdlg({'Sum from Row', 'to Row'}, title, 1, {num2str(round(picky(1))),num2str(round(picky(2)))});
    profheight = str2num(col_num{2}) - str2num(col_num{1})+1;
    B = zeros(1,profheight);
    A = zeros(1,profheight);
    yis = [str2num(row_num{1}) (str2num(row_num{2})+30)];
    for a = str2num(col_num{1}):str2num(col_num{2})
        xis = [a a];
        C = improfile(image_matrix, xis, yis);
        B(a) = sum(C);
        A(a) = a;
    end
   
    figure;
    fig_name = ['Summation Profile of Columns ' col_num{1} '-' col_num{2} ' between Rows ' row_num{1} '-' row_num{2}];
    plot(A,B); 
end
    set(get(gca, 'XLabel'), 'String', 'Distance along profile (Pixels)');
    set(get(gca, 'YLabel'), 'String', 'Pixel Intensity');
    set(gcf, 'NumberTitle', 'off', 'Name', fig_name);
   
end
                     