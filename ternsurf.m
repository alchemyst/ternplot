% TERNSURF plot surface diagram for ternary phase diagram
%   TERNSURF(A, B, Z) plots surface fitted over Z on ternary phase diagram for three components.  C is calculated
%      as 1 - A - B. Number of steps in axes will be enter by user as MAJORS
%
%   TERNSURF(A, B, C, Z) plots surface of Z on ternary phase data for three components A B and C.  If the values 
%       are not fractions, the values are normalised by dividing by the total. Number of steps in axes will be enter by user as MAJORS
%   
%   NOTES
%   - An attempt is made to keep the plot close to the default trisurf type.  The code has been based largely on the
%     code for TERNPLOT.
%   - The regular TITLE and LEGEND commands work with the plot from this function, as well as incrimental plotting
%     using HOLD.  Labels can be placed on the axes using TERNLABEL
%
%   See also TERNCONTOURF TERNPLOT TERNLABEL PLOT POLAR CONTOUR CONTOURF 

%       b
%      / \
%     /   \
%    c --- a 

% Author: Peter Selkin 20030507 based on TERNPLOT by Carl Sandrock 20020827
% Modified heavily by Carl Sandrock on resubmission

% To do
% Make TERNCONTOURF and TERNSURF

% Modifications
% 20031006 (CS) Added call to SIMPLETRI to plot triangular surface
% 20070107 (CS) Modified to use new structure (more subroutines)
% 20160405 (SA) Added an input argument 'major', and an output argument 'handle'
% 20161305 (SA) Removed 'Z' input argument, changed upper limit of nargin
%               from 4 to 6

% Modifiers
% CS Carl Sandrock
% SA Shahab Afshari

function handle = ternsurf(A, B, C, varargin) % Z arguement is removed

if nargin < 6 % it was orginally 4
    Z = C;
    C = 1 - (A+B);
end;

[varargin, majors] = extractpositional(varargin , 'majors', 10);


[fA, fB, fC] = fractions(A, B, C);
[x, y] = terncoords(fA, fB, fC);

% Sort data points in x order
[x, i] = sort(x);
y = y(i);
Z = Z(i);

% The matrixes we work with should be square for the triangulation to work
N = majors+1;

% Now we have X, Y, Z as vectors. 
% use meshgrid to generate a grid
Ar = linspace(min(fA), max(fA), N);
Br = linspace(min(fB), max(fB), N);
[Ag, Bg] = meshgrid(Ar, Br);
[xg, yg] = terncoords(Ag, Bg);

% ...then use griddata to get a plottable array
zg = griddata(x, y, Z, xg, yg, 'v4');
zg(Ag + Bg > 1) = nan;

% Make ternary axes
[hold_state, cax, next] = ternaxes(majors);

% plot data
tri = simpletri(N);

%tri = delaunay(xg, yg, zg);
handle = trisurf(tri, xg, yg, zg);
%h = trimesh(tri, xg, yg, zg);
view([-37.5, 30]);

if ~hold_state
    set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
end
