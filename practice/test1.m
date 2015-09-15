clear all;
close all;


ezcontourf('sin(3*x)*cos(x+y)', [0, 3, 0, 3])

% Change the default colormap to 'spring'
colormap('spring')

% Here we preserve the size of the image when we save it.

% Save the file as PNG
print('fig01','-dpng');


exit;