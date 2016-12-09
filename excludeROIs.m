function exclude_matrix = excludeROIs(image_matrix, roi_matrix_cell)
% exclude_matrix creates an exclusion matrix from the defined ROIs
% SYNTAX: exclude_matrix = excludeROIs(image_matrix, roi_matrix_cell)
% The exclusion matrix has the same dimensions as the image_matrix.
% roi_matrix_cell is a cell array of ROIs produced by the "define" function
% in imagedisp. The function combines all of these ROIs together into a
% single ROI which can then be passed as an exclusion mask to other
% subroutines

% Check arguments
imageok = checkarg(image_matrix,'numeric',NaN,NaN);
if(~imageok)
    error('Error in exclude_matrix. image_matrix must be a 2-d matrix');
end
nrow = size(image_matrix,1);
ncol = size(image_matrix,2);

ncell = numel(roi_matrix_cell);

% make the default exclude_matrix
exclude_matrix = ones(nrow,ncol);

% loop through each entry in roi_matrix_cell
for(i=1:ncell)
    exclude_matrix = exclude_matrix .* not(roi_matrix_cell{i});
end