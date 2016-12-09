function findcentre()
% findcentre finds the centre location of a circular image

global image_matrix

msgbox('Select approximate centre','Find Centre');
waitforbuttonpress;
[xapp, yapp] = ginput(1);

msgbox('Select maximum extent of useful image', 'Find Centre');
waitforbuttonpress;
[xmax, ymax] = ginput(1);

% Draw a series of lines radially outward from this point and calculate the
% profile along each line
nlines = 50;
delangle = 2*pi/nlines;
%rmax = size(image_matrix,2) - xapp;
rmax = sqrt((size(image_matrix,1) - yapp).^2 + (size(image_matrix,2) - xapp).^2);
xvec = zeros(0);
yvec = zeros(0);

for i=0:nlines-1
    angle = i * delangle;
    xi = xapp + rmax * cos(angle);
    yi = yapp + rmax * sin(angle);
    
    %Calculate profile
    xprofile = [xapp xi];
    yprofile = [yapp yi];
    [cx, cy, prof] = improfile(image_matrix,xprofile,yprofile);
    
    %Find co-ordinates of maximum
    [profmax, indexmax] = min(prof);
    xvec = [xvec; cx(indexmax)];
    yvec = [yvec; cy(indexmax)];
    
    text(cx(indexmax),cy(indexmax),'+','HorizontalAlignment','center');
end

% Fit to a circle
[xc,yc,R] = circfit(xvec,yvec);
% Plot the circle (overlaid)
hold on
text(xc,yc,'+','HorizontalAlignment','center');
circle([xc yc], R, 100);