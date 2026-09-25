function p=plotBody(T,L,varargin)
% plots a body in format of cube with dimension of Lx, Ly, Lz and
% orientation R and position p (T=[R p;0 1])
%
% INPUTS:
%   T => transformation matrix with rotation and translation.
%           T=[R p;0 1];
%   L => body length along x,y and z direction.
%
%Optional:
% color  => STRING, the color patched for the cube.
%         List of colors
%         b blue
%         g green
%         r red
%         c cyan
%         m magenta
%         y yellow
%         k black
%         w white
% alpha => value between 0 and 1 indication the face alpha (transparency)
%
% OUPUTS:
% Plot a figure.
%
% Author: Marcos R. Fernandes
% email: eng.marofe@gmail.com
% last update: 11/16/2019
%
if nargin==3
    color=varargin{end};
    alpha=1;
else
    if nargin==4
        color=varargin{end-1};
        alpha=varargin{end};
    else
        if nargin==5
            ax=varargin{end};
            color=varargin{end-1};
            alpha=varargin{end-2};
        else
        alpha=1;
        color='b';
%         ax=axes('default');
        end
    end
end

% Define the vertexes of the unit cubic centered at the origin (0,0,0)
ver = [1 1 0;
    0 1 0;
    0 1 1;
    1 1 1;
    0 0 1;
    1 0 1;
    1 0 0;
    0 0 0]-[1 1 1]/2;

%  Define the faces of the unit cubic
fac = [1 2 3 4;
    4 3 5 6;
    6 7 8 5;
    1 2 8 7;
    6 7 1 4;
    2 3 5 8];
ver=ver*T(1:3,1:3)';
origin=T(1:3,4);
cube = [ver(:,1)*L(1)+origin(1),ver(:,2)*L(2)+origin(2),ver(:,3)*L(3)+origin(3)];
p=patch('Faces',fac,'Vertices',cube,'FaceColor',color,'FaceAlpha',alpha);
axis equal
grid on
drawnow
end

