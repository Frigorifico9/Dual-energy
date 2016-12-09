function flipimagelr()
% Flip image_matrix vertically and redisplay
global image_matrix

image_matrix = fliplr(image_matrix);
show;


end