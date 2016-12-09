function vararout = define(shape)
%
%this function defines masks for different regions of interest with different shapes 
%(namely: rectangles, polygons and circles). the different masks are stored in the
%cell array 'bwrois'. 
%
%   by       version       updates
%omoussa        0       first version
%

global num_roi bwrois roi_types roich roidh
global image_matrix image_width  image_height
global choosehandle removehandle
global lines
global imagehandle

%if the region of interest is to be a polygon, then use the built in function "roipoly".
%bwroi is a matrix of the same size as image with ones inside the roi and zeros outside, 
%xis and yis are the coordinates of the various vertices.
if strcmp(shape, 'poly')
    [bwroi, xis, yis]= roipoly;

% %if the roi is a rectangle, then get two corners by mouse clicks.
% %bwroi is a matrix containing the coordinates of top left and bottom right corners.    
% elseif strcmp(shape, 'rect')
%     [x1, y1] = ginput(1);           %get first point
%     temp_mark  = text(x1, y1, '+'); %draw a "+" sign where first point is
%     [x2, y2] = ginput(1);           %get second point
%     xis=[x1;x2;x2;x1;x1];            %rectangle coordinates to draw roi borders
%     yis=[y1;y1;y2;y2;y1];
%     bwroi = round([min(xis) min(yis); max(xis) max(yis)]);
%     delete(temp_mark);              %erase "+" sign
    
%Alternate method for dealing with rectangular ROIs implemented by Brian
%King. Treat the rectangular ROI in the same way as the polygonal. Create a
%mask for the image. This eliminates the need for keeping track of the type
%of ROI and other assorted complications. The disadvantage is a larger
%amount of storage space required since we're now storing an entire mask as
%opposed to just the co-ordinates.
elseif strcmp(shape, 'rect')
    [x1, y1] = ginput(1);           %get first point
    temp_mark  = text(x1, y1, '+'); %draw a "+" sign where first point is
    [x2, y2] = ginput(1);           %get second point
    xis=[x1;x2;x2;x1;x1];            %rectangle coordinates to draw roi borders
    yis=[y1;y1;y2;y2;y1];
    bwroi = roipoly(image_matrix,xis,yis);
    delete(temp_mark);
    
%if the roi is a circle: not implemented yet
elseif strcmp(shape, 'circ')
    

% If the ROI is a rectangle whose upper-left and lower-right vertices are
% entered in manually
elseif strcmp(shape, 'manu')
    
    % Defrine properties for input dialog box
    prompt = {'Upper-left Vertex (x, y)','Lower-right Vertex (x, y)'};
    title = 'Coordinates for Rectangular ROI';
    defaultanswer ={'180, 120', '320, 190'};
    options.Resize='on';
    options.WindowStyle='normal';
    
    % Get rectangular coordinates fron input dialog
    coords = inputdlg(prompt, title, 1, defaultanswer, options);
    ulVertex = str2num(coords{1});
    lrVertex = str2num(coords{2});
    x1 = ulVertex(1);
    y1 = ulVertex(2);
    x2 = lrVertex(1);
    y2 = lrVertex(2);
    
    % Draw the rectangle
    xis=[x1;x2;x2;x1;x1];
    yis=[y1;y1;y2;y2;y1];
    bwroi = roipoly(image_matrix,xis,yis);
        
end

    %for all roi types do
    num_roi = num_roi + 1;      %increment the total number of rois
    roi_types{num_roi} = shape; %save the shape of the roi, will need it in stats.m 
    bwrois{num_roi}   = bwroi; %save mask in a cell array
    lines{num_roi}    = line(xis, yis); %draw the roi borders

    [xtext, vertex_no]   = max(xis);        %most right vertex
    xtext=xtext+5; ytext = yis(vertex_no);  %text coordinates
    text(xtext, ytext, num2str(num_roi));   %write number of roi beside it
    
    %add a menu item to the choose menu indicating the added roi
    roich(num_roi) = uimenu(choosehandle, 'Label', num2str(num_roi),...
                                         'Callback', 'choose(get(gcbo, ''Position''))');

                                     
    %choose the most recently defined roi as the current
    choose(num_roi);
    
    %add a menu item representing the defined roi to the remove menu 
    roidh(num_roi) = uimenu(removehandle, 'Label', num2str(num_roi),...
                                         'Callback', 'remove(get(gcbo, ''Position''))');     
                                                  
 
%end of file