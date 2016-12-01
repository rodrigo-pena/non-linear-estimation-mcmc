function fig = plot_matrices( x, Y, Z, xr )
%PLOT_MATRICES plots the matrices x*x', Y, Z, and xr*xr'
%
% Usage:
%   fig = plot_matrices( x, Y, Z, xr );
%   plot_matrices( x, Y, Z, xr );

interpreter = 'latex';
fontsize = 20;

fig = figure('Position', [100, 100, 1049, 895]);

subplot(221);
imagesc(x * x');
title('$$xx^{T}$$', ...
    'interpreter', interpreter, ...
    'FontSize', fontsize);

subplot(222);
imagesc(Z);
title('$$Z$$', ...
    'interpreter', interpreter, ...
    'FontSize', fontsize);

subplot(223);
imagesc(Y);
title('$$Y = \sqrt{\frac{\lambda}{N}} xx^{T} + Z$$', ...
    'interpreter', interpreter, ...
    'FontSize', fontsize);

subplot(224);
imagesc(xr * xr');
title('$$x_{r}x_{r}^{T}$$', ...
    'interpreter', interpreter, ...
    'FontSize', fontsize);

end
