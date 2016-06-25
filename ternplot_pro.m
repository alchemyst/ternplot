% TERNPLOT_PRO plot ternary phase diagram, where the facecolors of the
% triangular cells (in grey scale) represent density of points with respect
% to overall counts of data. 

%       b
%      / \
%     /   \
%    c --- a 

% HFINAL = TERNPLOT_PRO(dataA, dataB, dataC, NUM_AXES_STEPS, NUM_COLOR_CLASSES)
% plots ternary phase diagram for three components,i.e. dataA,dataB,
% and dataC, each being as Nx1 vector, where N is overall counts of data.
% NUM_AXES_STEPS, is a user specified number of steps (major ticks) on a-c, c-b, and b-a axes. 
% NUM_COLOR_CLASSES, is a user specified number of classes of assigned
% facecolor of triangulare cells corresponding to computed point density within a particular cell.
% For example, NUM_AXES_STEPS = 10, will divide a-c, c-b, and b-a axes into
% 10 axial steps, and NUM_COLOR_CLASSES = 20 will make a colorbar of 20 different
% colors (grey-scaled), where each color represent a particular density range.  

% Note: the main goal of the this code is to: first, capturing the triangular cells
% and treat them as polygons using PATCH function (a pre-defined function in MATLAB). 
% The next steps are employing the INPOLYGON fucntion (a pre-defined function in MATLAB)
% for counting the number of points within each polygon, and application of 
% TERNPLOT along with PATCH function to plot the final density ternary plot.

% Author: Shahab Afshari 20160428
% City University of New York/City College
% Civil Engineering Department

% To Do

% Modifications
% SA The value of 'majors' at the final plot is fixed to 10 to avoid tick
%    label interruption

% Modifiers
% (SA) Shahab Afshari

function hfinal = ternplot_pro(dataA, dataB, dataC, num_axes_steps, num_color_classes)
% preliminary effort for getting the indices of values of verticies and faces of
% each triangular cell generated according to desired number of axial steps
h0 = figure;
elev = zeros(num_axes_steps,1);
experimental = [linspace(0,1,num_axes_steps)',linspace(1,0,num_axes_steps)',elev];
%%%%
Z = experimental(:, 3)';
[fA, fB, fC] = fractions(experimental(:, 1)', experimental(:, 2)', experimental(:, 3)');
[x, y] = terncoords(fA, fB, fC);
% Sort data points in x order
[x, i] = sort(x);
y = y(i);
Z = Z(i);
% The matrixes we work with should be square for the triangulation to work
N = num_axes_steps+1;
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
[hold_state, cax, next] = ternaxes(num_axes_steps);
% plot data
tri = simpletri(N);
h = trisurf(tri, xg, yg, zg);
view([-37.5, 30]);
if ~hold_state
    set(gca,'dataaspectratio',[1 1 1]), axis off;
    set(cax,'NextPlot',next);
end
view(0, 90);
set(h, 'FaceColor', 'none');
v = get(h, 'Vertices');
f = get(h, 'Faces');
close(h0)
clear fA fB fC x y N Ag Bg Ar Br xg yg hold_state cax next
%%%%
f2 = f;
f2(ismember(f2(:,1),find(isnan(v(:,3)))),:)=[];
f2(ismember(f2(:,2),find(isnan(v(:,3)))),:)=[];
f2(ismember(f2(:,3),find(isnan(v(:,3)))),:)=[];

[fA, fB, fC] = fractions(dataA, dataB, dataC);
[x, y] = terncoords(fA, fB, fC);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

total_data_count = length(dataA);
% count points located within polygon extent
for i = 1:size(f2, 1)
    inpoly_data_count = inpolygon(x, y, v(f2(i, :), 1), v(f2(i, :), 2));
    density_i(i, 1) = sum(inpoly_data_count)/total_data_count;
end
%
% specify the RGB ranges of the colorbar (here grey scale is applied)
c_mat_down = 0;
c_mat_up = round(1.05*max(density_i), 2, 'significant');
c_mat = repmat(linspace(1, 0, num_color_classes-1)', 1, 3);
c_mat_1 = linspace(c_mat_down, c_mat_up, size(c_mat,1) + 1)';
c_mat = [c_mat_1(1:end-1), c_mat_1(2:end), c_mat];
%
% Plot Ternary Diagram 
hfinal = figure;
% here the 'majors' is fixed to 10 to avoid text-lable interruption.
ternplot(dataA, dataB, dataC, 'majors', 10, '.', 'color', 'none')
set(gca, 'visible', 'off');
hold on
for i = 1: size(f2,1)
    if i < 2
        inpoly_data_count = sum(inpolygon(x, y,v(f2(i,:),1),v(f2(i,:),2)));
        density_i_dum = inpoly_data_count/total_data_count;
        patch('Faces',f2(1,:),'Vertices',v,'FaceColor',c_mat(find(density_i_dum<c_mat(:,2),1),3:end),'LineWidth',1);
    else
        inpoly_data_count = sum(inpolygon(x, y,v(f2(i,:),1),v(f2(i,:),2)));
        density_i_dum = inpoly_data_count/total_data_count;
        patch('Faces',f2(i,:),'Vertices',v,'FaceColor',c_mat(find(density_i_dum<c_mat(:,2),1),3:end),'LineWidth',1);
    end
end
set(gcf, 'Colormap', c_mat(:,3:end));
modified_color_bar = num2str(...
    round(100*c_mat(:,2),2));
h_colbar = colorbar('XTickLabel',{num2str(round(c_mat_down,2));...
modified_color_bar}, ...
    'XTick',linspace(0,1,num_color_classes)','location','eastoutside');
ylabel(h_colbar,['Density (% of Tot. Counts),','Tot. Counts =', num2str(length(dataA))],'fontsize',10,'rotation',90)
set(gca, 'visible', 'off');
%ht = ternlabel('b^{*}', 'f^{*}', 'm^{*}');
% h_text = ternlabel('b', 'f', 'm');
% h_text(1).FontSize = 14;
% h_text(2).FontSize = 14;
% h_text(3).FontSize = 14;
%
end
