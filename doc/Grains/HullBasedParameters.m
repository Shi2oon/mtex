%% Convex Hull Based Shape Parameters
%
%%
% In this section we discuss geometric properties of grains that are
% related to the convex hull of the grains. In the follwing we illustarte
% these properties with some artificial grain shapes

% import the artificial grain shapes
mtexdata testgrains silent

% select and smooth a few interesting grains
grains = smooth(grains('id',[4 5 20 22 26 27 29 34 42 44 49 51 50]),3);

%%
% <grain2d.smooth.html Smoothing> of grains is necessary since otherwise
% many grain segments are either vertical or horizontal (for a square grid)
% and perimeters rather measure the "cityblock" distance. See also
% <https://t.co/1vQ3SR8noy?amp=1> for examples. Note, that for very small
% grains, the error between the smoothed grains and their convex hull may
% lead to unsatisfactory results.
%
% The convex hull of a list of grains can be computed by the command
% <grain2d.hull.html |hull|>. The result is a list of convex grains which
% can be analyzed almost analogously like the original list of grains.

chGrains = grains.hull;

plot(grains,'micronbar','off')
legend off
hold on
plot(chGrains.boundary,'lineWidth',2,'lineColor','r')
hold off

%%
% One major difference is that the grains may now overlap. Accordingly, a
% boundary of the convex hull is not a boundary between two adjecent grains
% anymore. Therefore, the second phase in all boundary segments is set to
% not indexed.
%
%% Deviation from fully convex shapes
%
% There are various measures to describe the deviation from fully convex
% shapes, i.e. the lobateness of grains. Many of these are based on the
% differences between the convex hull of the grain and the grain itself.
% Depending on the type of deviation from the fully convex shape, some
% measures might be more appropriate over others.
%
% One measure is the relative difference between the grain perimeter and
% the perimeter of the convex hull. It most strongly discriminizes grains
% with thin, narrow indenting parts, e.g. fracture which not entirely
% dissect a grain.

deltaP = 100 * (grains.perimeter-chGrains.perimeter) ./ grains.perimeter;

%%
% A similar measure is the <grain2d.paris.html paris> which stands
% for Percentile Average Relative Indented Surface and gives the
% difference between the actual perimeter and the perimeter of the convex
% hull, relative to the convex hull.

paris = 200 * (grains.perimeter - chGrains.perimeter) ./ chGrains.perimeter;

%%
% The relative difference between the grain area and the area within the
% convex hull is more indicative for a broad lobateness of grains

deltaA = 100 * (chGrains.area - grains.area) ./ chGrains.area;

%%
% The total deviation from the fully convex shape can be expressed by

radiusD = sqrt(deltaP.^2 + deltaA.^2);

%%
% Lets visualize all these shape parameters in one plot

plot(grains,deltaP,'layout',[2 2],'micronbar','off')
mtexTitle('deltaP')

nextAxis
plot(grains,grains.paris,'micronbar','off')
mtexTitle('paris')


nextAxis
plot(grains,deltaA,'micronbar','off')
mtexTitle('deltaA')

nextAxis
plot(grains,radiusD,'micronbar','off')
mtexTitle('radiusD')
mtexColorbar
