clear all;
close all;
x  = 0: .1 : 2*pi;
y1 = cos(x);
y2 = sin(x);

plot(x, y1, 'b', x, y2, 'r-.', 'LineWidth', 2)

grid on 
% Plot y1 vs. x (blue, solid) and y2 vs. x (red, dashed)



set(gca,'XTick',0:2*pi);
set(gca,'YTick',-1.5:1.5);

% Here we preserve the size of the image when we save it.

% Save the file as PNG
print('fig01','-dpng');


exit;