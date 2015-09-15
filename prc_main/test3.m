clear all;
close all;

points = linspace(-2, 0, 20);
[X, Y] = meshgrid(points, -points);

% Define the function Z = f(X,Y)
Z = 2./exp((X-.5).^2+Y.^2)-2./exp((X+.5).^2+Y.^2);

% "phong" lighting is good for curved, interpolated surfaces. "gouraud"
% is also good for curved surfaces
surf(X, Y, Z)
view(30, 30)
shading interp
light
lighting phong

title('Lighting phong')

print('fig01','-dpng');

exit;