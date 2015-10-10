clear all;
close all;


load mandrill X map

% Create the image display using the image command

image(X)

% Use the colormap specified in the image data file
colormap(map)

% Turn the axes off
axis off

% Add title
title('Mandrill')

print('fig01','-dpng');
exit;