function [theta, nmeas, err] = diff_extract(image_matrix, centre, OID, ringwidth, ...
    minradius, maxradius, pix_convert, background);
%diff_extract extracts the radial diffraction pattern from image_matrix
%with centre at centre.  OID is the object - image distance.
%Equally spaced rings (each ring has width ringwidth) are integrated about
%the centre to get the radial diffraction pattern.
%centre is a 2-vector.  1st element contains x value of centre point.  2nd
%element contains y value of centre point.  Both values are in centimeters
%Ringwidth is a scalar representing the width of each ring (in centimeters)
%Minradius is a scalar represesnting the minimum extent of the diffraction
%pattern (in centimeters) this is typically defined by the size of the beam
%stop
%Maxradius is a scalar representing the maximum extent of the diffraction
%pattern (in centimeters)
%OID is the object - image distance expressed in centimeters
%pix_convert is the ratio of pixels to centimeters (pixels/cm)
%background is the average background level
%theta is an array of angles (in radians)
%nmeas is the integrated sum of pixel brightness in each ring

% bwrois contains ROIs selected by user to be excluded
global num_roi bwrois

%Maximum pixel value in image.
maxpixel = 65535;

%Create double version of the image matrix.  Need to add 1 for accurate
%conversion (see Matlab Help files - 8-Bit and 16-Bit indexed images)
%Divide by maxpixel to normalize.
%Below line if background is highest value
image_double = background - (double(image_matrix) + 1);

%Below line if background is smallest value
%image_double = (double(image_matrix) + 1) - background;

%image_double = -(65535 - image_double);

%Locate pixel locations of relevant points
xcentre_pix = centre(1) * pix_convert;
ycentre_pix = centre(2) * pix_convert;
xmax = size(image_double,2);
ymax = size(image_double,1);
xmin_pix = max([floor(xcentre_pix - maxradius * pix_convert),1]);
xmax_pix = min([ceil(xcentre_pix + maxradius * pix_convert),xmax]);
ymin_pix = max([floor(ycentre_pix - maxradius * pix_convert),1]);
ymax_pix = min([ceil(ycentre_pix + maxradius * pix_convert),ymax]);

%Setup rings, theta, nmeas vectors
%rings vector contains maximum radius of each ring (in cm)
%theta vector is the central angle of each ring (in degrees)
numrings = round((maxradius - minradius)/ringwidth);
rings = linspace(minradius + ringwidth, maxradius, numrings);
theta = atan((rings - ringwidth/2)/OID) * 180 / pi; % Theta in degrees
%nmeas = zeros(1,numrings);
%err = zeros(1,numrings);
pixelsperring = zeros(1,numrings);

excludemat = excludeROIs(image_matrix,bwrois);
excludemat = excludemat(ymin_pix:ymax_pix,xmin_pix:xmax_pix);

%Truncate the image to only the diffraction pattern
id_trunc = image_double(ymin_pix:ymax_pix,xmin_pix:xmax_pix);
xmax_pix = xmax_pix - xmin_pix + 1;
xcentre_pix = xcentre_pix - xmin_pix + 1;
xmin_pix = 1;
ymax_pix = ymax_pix - ymin_pix + 1;
ycentre_pix = ycentre_pix - ymin_pix + 1;
ymin_pix = 1;

risq = (rings * pix_convert).^2;

% BELOW SECTION VECTORIZES THE CIRCULAR AVERAGING TO IMPROVE SPEED
% Attempt alternate method to perform computation, construct the problem in
% vectorized form, remove loops if possible

% Construct matrices containing the x and y coordinates for each point in
% the image
xpixels = ones(ymax_pix-ymin_pix+1,1) * linspace(xmin_pix,xmax_pix,xmax_pix-xmin_pix+1);
ypixels = linspace(ymin_pix,ymax_pix,ymax_pix-ymin_pix+1)' * ones(1,xmax_pix-xmin_pix+1);
% Compute matrix containing distance (in pixels) from centre to each point
rdist = sqrt((xpixels - xcentre_pix).^2 + (ypixels - ycentre_pix).^2);
% Determine which elements less than minimum or greater than maximum distance
rlarge = rdist > maxradius*pix_convert;
rsmall = rdist < minradius*pix_convert;
validr = (not(rlarge)) .* (not(rsmall));
% Reshape the distance and image vectors, exclude the invalid distance 
% entries The nonzeros function MUST retain the ordering of
% the elements in order for this to work properly. Otherwise, have to
% reshape the arrays manually then exclude the zero elements.
% Also exclude any regions that were selected as ROIs
minpix = min(min(id_trunc));
maxpix = max(max(id_trunc));
if(minpix <= 0 && maxpix > 0)
    id_trunc_shift = id_trunc - minpix + 1;
else
    id_trunc_shift = id_trunc;
end
rdistvalid = nonzeros(rdist .* validr .* excludemat);
id_trunc_valid = nonzeros(id_trunc_shift .* validr .* excludemat) + minpix - 1;

% % Attempt to calculate ring pattern without using loops (vectorized)
% % This results in arrays that are too large for Matlab to handle
% numpix = numel(id_trunc_valid);
% rdist_mat = rdistvalid * ones(1,numrings);
% id_trunc_mat = id_trunc_valid * ones(1,numrings);
% minring_rad = pix_convert * ones(numpix,1) * linspace(minradius,maxradius-ringwidth,numrings);
% maxring_rad = minring_rad + (ringwidth*pix_convert);
% %maxring_rad = pix_convert * ones(numpix,1) * linspace(minradius+ringwidth,maxradius,numrings);
% ringindices = rdist_mat >= minring_rad;
% ringindices = ringindices .* (rdist_mat < maxring_rad);
% idring = id_trunc_mat .* ringindices;
% nmeas = mean(idring);
% err = std(idring);

% loop through each rings and calculate
nmeas = [];
err = [];
rmax = minradius .* pix_convert;
for(i=1:numrings)
    rmin = rmax;
    rmax = rmin + (ringwidth .* pix_convert);
    %rmin = (rings(i) - ringwidth) .* pix_convert;
    %rmax = rings(i) .* pix_convert;
    ringindices = rdistvalid < rmax;
    ringindices = ringindices .* (rdistvalid > rmin);
%    ringindices = rdistvalid > rmin .* rdistvalid < rmax;
    idring = nonzeros(id_trunc_valid .* ringindices);
    nmeas = [nmeas, mean(idring)];
    err = [err, std(idring)/sqrt(size(idring,1))];
end

% END VECTORIZED VERSION

% BELOW SECTION USES MULTIPLE LOOPS TO CALCULATE AVERAGES PIXEL BY PIXEL
% 
%     
% %Loop through each pixel in the ROI, add brightness of each pixel into the
% %appropriate ring.
% for xi= xmin_pix:xmax_pix 
%     for yi = ymin_pix:ymax_pix
%         rsq = (xi-xcentre_pix).^2 + (yi-ycentre_pix).^2;  % rsq in pixels squared
%         if rsq <= (maxradius * pix_convert).^2 && rsq >= (minradius * pix_convert).^2
%             for ri = numrings-1:-1:1
%                 %risq = (rings(ri) * pix_convert).^2;
%                 if rsq > risq(ri)
%                     nmeas(ri+1) = nmeas(ri+1) + id_trunc(yi,xi);
%                     pixelsperring(ri+1) = pixelsperring(ri+1) + 1;
%                     break
%                 end
%                 %This check will catch the innermost ring (skipped
%                 %otherwise)
%                 if ri == 1
%                     nmeas(ri) = nmeas(ri) + id_trunc(yi,xi);
%                     pixelsperring(ri) = pixelsperring(ri) + 1;
%                 end
%             end
%         end
%     end
% end
% 
% %Calculate average brightness of pixels in each ring
% nmeas = nmeas ./ pixelsperring;
% 
% %Run through loop second time to calculate variance
% for xi= xmin_pix:xmax_pix 
%     for yi = ymin_pix:ymax_pix
%         rsq = (xi-xcentre_pix).^2 + (yi-ycentre_pix).^2;  % rsq in pixels squared
%         if rsq <= (maxradius * pix_convert).^2 && rsq >= (minradius * pix_convert).^2
%             for ri = numrings-1:-1:1
%                 %risq = (rings(ri) * pix_convert).^2;
%                 if rsq > risq(ri)
%                     err(ri+1) = err(ri+1) + (id_trunc(yi,xi) - nmeas(ri+1)).^2;
%                     break
%                 end
%                 %This check will catch the innermost ring (skipped
%                 %otherwise)
%                 if ri == 1
%                     err(ri) = err(ri) + (id_trunc(yi,xi) - nmeas(ri)).^2;
%                 end
%             end
%         end
%     end
% end
% 
% % Calculate standard deviation of the mean
% err = sqrt(err ./ ((pixelsperring - 1) .* pixelsperring));
%
% END LOOPING VERSION