% TERNPLOT plot ternary phase diagram
%   TERNPLOT(A, B) plots ternary phase diagram for three components.  C is calculated
%      as 1 - A - B.
%
%   TERNPLOT(A, B, C) plots ternary phase data for three components A B and C.  If the values 
%       are not fractions, the values are normalised by dividing by the
%       total.
%
%   TERNPLOT(A, B, C, LINETYPE) the same as the above, but with a user specified LINETYPE (see PLOT
%       for valid linetypes).
%
%   The parameters above can be followed by parameter/value pairs to
%   specify additional properties as with the PLOT function. All
%   unrecognized options will be passed through to the PLOT command. The
%   following options are used by this function:
%
%   Parameter Default Description
%   --------- ------- -----------
%   majors    10      The number of major intervals to divide the plot grid into.
%             
%
%   Example
%
%       plot(x, y, 'majors', 10)
%
%   NOTES
%   - An attempt is made to keep the plot close to the default plot type.  The code has been based largely on the
%     code for POLAR.       
%   - The regular TITLE and LEGEND commands work with the plot from this function, as well as incrimental plotting
%     using HOLD.  Labels can be placed on the axes using TERNLABEL
%
%   See also TERNLABEL PLOT POLAR

%       b
%      / \
%     /   \
%    c --- a 

% Author: Carl Sandrock 20020827

% To do

% Modifications
% 20160405 (SA) Added an input argument 'major'

% Modifiers
% CS Carl Sandrock
% SA Shahab Afshari

function handles = ternplot(A, B, C, varargin)

if nargin < 3
    C = 1 - (A+B);
end;

[varargin, majors] = extractpositional(varargin, 'majors', 10);

[fA, fB, fC] = fractions(A, B, C);

[x, y] = terncoords(fA, fB, fC);

% Sort data points in x order
[x, i] = sort(x);
y = y(i);

% Make ternary axes
[hold_state, cax, next] = ternaxes(majors);

% plot data
q = plot(x, y, varargin{:});
if nargout > 0
    handles = q;
end
if ~hold_state
    set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
end
