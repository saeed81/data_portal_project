clear all;
close all;
opengl('save','hardware');

x  = 0: 0.01: 2*pi;
y1 = cos(x);
y2 = sin(x);

set(gcf,'Renderer','OpenGL');

plot(x, y1, 'b', x, y2, 'r-.', 'LineWidth', 2);

grid on; 
% Plot y1 vs. x (blue, solid) and y2 vs. x (red, dashed)



set(gca,'XTick',0:2*pi);
set(gca,'YTick',-1.5:1.5);

% Here we preserve the size of the image when we save it.

% Save the file as PNG

%figure(1);


%saveas(1,'fig01.tif');

%print('fig01','-dpng');


%set(0, 'DefaultFigureRenderer', 'OpenGL');


%print('fig01','-dsvg','-noui','-opengl');
set(gcf,'renderer','opengl');

%set('renderer','opengl');
%print('fig01','-dpng','-noui','-opengl','-r72');

print('fig01','-dsvg','-noui','-opengl');


%saveas(gcf, 'fig01.svg');


%print('fig01','-dpng','-noui','-opengl');

%print('fig01','-dpng','-noui','-opengl','-r72')

%print('fig01','-dpng','-noui','-opengl');

%saveas(gcf,'fig01.svg')


%savefig('fig01.png','compact')
exit;