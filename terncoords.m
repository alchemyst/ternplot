% TERNCOORDS calculate rectangular coordinates of fractions on a ternary plot
%   [X, Y] = TERNCOORDS(FA, FB) returns the rectangular X and Y coordinates
%   for the point with a fraction defined by FA and FB.  It is assumed that
%   FA and FB are sensible fractions.
%
%   [X, Y] = TERNCOORDS(FA, FB, FC) returns the same.  FC is assumed to be
%   the remainder when subtracting FA and FB from 1.

%       b
%      / \
%     /   \
%    c --- a 

% Author: Carl Sandrock 20050211

% Modifications
% 20160405 (SA) rotation of the ternary axes in clockwise/counter-clockwise order 
%               (User must directly switch to either options via 
%               commenting/uncommenting the associated lines.
%               Moreover, any modification on terncoords must be adjusted 
%               with associated lines on ternaxes)

% Modifiers
% SA Shahab Afshari

function [x, y] = terncoords(fA, fB, fC)
if nargin < 3
    fC = 1 - (fA + fB);
end

direction = 'clockwise';

if ~strcmp(direction, 'clockwise')
    y = fB*sin(deg2rad(60));
    x = fA + y*cot(deg2rad(60));
else
    y = fC*sin(deg2rad(60));
    x = 1 - fA - y*cot(deg2rad(60));
end