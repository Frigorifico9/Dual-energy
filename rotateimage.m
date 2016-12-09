function rotateimage()
% Rotate image_matrix by 180 degrees and redisplay
global image_matrix

image_matrix = rot90(image_matrix,2);
show;


end