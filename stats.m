function varargout = stats(roi)
%
%this function calculates the statistics for the chosen region of interest (or the
%whole image). The masks for the various rois were stored upon creation by define.m 
%in the cell array 'bwrois'. different shapes of rois are treated differently to get
%a vector of pixel values which are within the roi. then statistics is done the same
%way for all types of rois.
%
%   by       version       updates
%omoussa        0       first version
%

global roi_vectors
global image_matrix image_height image_width
global bwrois roi_types cur_roi
global count

%the whole image is a roi of type rectangle
if strcmp(roi, 'image')
    %Original rectangular ROI treatment specifying co-ordinates only
    %bwroi = [ 1  1; image_width image_height]; %corners' coordinates
    %cur_roi_type = 'rect';
    %Modified ROI treatment storing the entire rectangular mask
    bwroi = logical(ones(image_height, image_width));
    
%for the chosen roi    
elseif strcmp(roi, 'chosenroi')
    bwroi = bwrois{cur_roi};             %get mask
    cur_roi_type = roi_types{cur_roi};   %get shape
end

% Modified stats routine. bwroi contains a mask of the ROI in all cases.
% Type of ROI is not relevant anymore. Simpler to code
count = nnz(bwroi);
% Need to make sure there are no zero values in the image_matrix. Shift
% everything (temporarily)
minpixel = min(min(image_matrix));
maxpixel = max(max(image_matrix));
if(minpixel <= 0 && maxpixel >= 0)
    image_cp = image_matrix + minpixel + 1;
    roi_vector = double(nonzeros(immultiply(image_cp,bwroi))) - double(minpixel) - 1;
    clear image_cp;
else
    roi_vector = double(nonzeros(immultiply(image_matrix,bwroi)));
end

%roi_vectors{cur_roi} = roi_vector;
% Generate the statistical details
max_intensity  = max(roi_vector);
min_intensity  = min(roi_vector);
median_intensity = median(roi_vector);
mean_intensity = mean(roi_vector);      %calculate mean
std_intensity  = std(roi_vector);       %and standard deviation
stdm_intensity = std_intensity/sqrt(count);%standard deviation of mean



% % Original stats calculation
% %if length(roi_vectors{cur_roi})~=0
% %for polygons
% if strcmp(cur_roi_type, 'poly')
%     roi_matrix = double(bwroi); %because 'bwroi' is unit16
%     count = nnz(roi_matrix);    %Number of Non-Zero elements (ones)
%     
%     %make a vector of pixel values contained within the roi
%     k = 0, while k < count
%         for i = 1:image_height
%             for j = 1:image_width
%                 %if the value of the mask pixel is not zero (one), add the 
%                 %corresponding element in the image matrix
%                 if roi_matrix(i, j) ~= 0
%                     k=k+1;
%                     roi_vector(k) = double(image_matrix(i,j)); 
%                 end
%             end
%         end
%     end
% 
% %for rectangles    
% elseif strcmp(cur_roi_type, 'rect')
%     
%     %make a smaller matrix containing only the pixels within the roi
%     roi_matrix = double(image_matrix(bwroi(1,2):bwroi(2,2),...
%                                      bwroi(1,1):bwroi(2,1)));
% 
%     %number of elements = #of columns * #of rows
%     count      = size(roi_matrix, 1)*size(roi_matrix, 2);
%     
%     %reshape the matrix into a vector (# of rows = 1)
%     roi_vector = reshape(roi_matrix, 1, count);
%     
% end
% 
%     %for all kinds of rois, do:
%     roi_vector     = sort(roi_vector);      %sort the pixel values
%     roi_vectors{cur_roi} = roi_vector;      %store the sorted vector for later use
%     
%     max_intensity  = roi_vector(count);     %maximum value is the last value
%     min_intensity  = roi_vector(1);         %minimum value is the first value
%     median_intensity = roi_vector(round(count/2));%median is the middle value
%     mean_intensity = mean(roi_vector);      %calculate mean
%     std_intensity  = std(roi_vector);       %and standard deviation
%     stdm_intensity = std_intensity/sqrt(count);%standard deviation of mean

bin_width = 1;
bins = min_intensity:bin_width:max_intensity;
histogram_data = hist(roi_vector, bins);
histogram_fig = figure;
histogram_axes = stairs(bins, histogram_data);


%compose message for display
box_message = {['Number of pixels:      ', num2str(count)];
               ['Maximum Intensity:    ', num2str(max_intensity)];
               ['Minimum Intensity:     ', num2str(min_intensity)];
               ['Mean Intensity:         ', num2str(mean_intensity)];
               ['Median Intensity:       ', num2str(median_intensity)];
               ['Standard deviation:   ', num2str(std_intensity)];
               ['Std of mean:            ', num2str(stdm_intensity)] };

%title of message display        
box_title   = ['Stats for ROI ', num2str(cur_roi)];
%display the statistics in a message box
box_handle  = msgbox(box_message, box_title);            


% Print results

fprintf('\n  RESULTS\n\n');
fprintf('Number of pixels:   %d\n', count);
fprintf('Maximum Intensity:  %d\n', max_intensity);
fprintf('Minimum Intensity:  %d\n', min_intensity);
fprintf('Mean Intensity:     %d\n', mean_intensity);
fprintf('Median Intensity:   %d\n', median_intensity);
fprintf('Standard deviation: %d\n', std_intensity);
fprintf('Std dev of mean:    %d\n', stdm_intensity);
fprintf('\n');
    
end



%end of file