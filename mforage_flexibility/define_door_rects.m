function [doorRects, squareXpos, squareYpos] = define_door_rects(backRect, xCenter, yCenter, doorPix)
% function to draw 12 doors on the background square provided in backRect
% will work if backRect is placed in the centre by draw_background.m
n_doors = 4;
% get coordinates of background Rect
centeredRect = CenterRectOnPointd(backRect, xCenter, yCenter);
scale = .8;
xPix = (centeredRect(3) - centeredRect(1))*scale; % get the number of x pixels in the space for the doors
yPix = (centeredRect(4) - centeredRect(2))*scale;

squareXpos = centeredRect(1) + centeredRect(1)*((1-scale)/2) + [xPix*0.125, xPix*0.375, xPix*0.625, xPix*.875];
squareYpos = centeredRect(2) + centeredRect(1)*((1-scale)/2) + [yPix*0.125, yPix*0.375, yPix*0.625, yPix*.875];
doorCoords = combvec(squareYpos, squareXpos); 
doorCoords = [doorCoords(2,:); doorCoords(1,:)];
doorBase = [0 0 doorPix, doorPix];

% make rectangle coordinates
doorRects = nan(4,n_doors^2);

for countDoors = 1:n_doors^2
    doorRects(:, countDoors) = CenterRectOnPointd(doorBase, doorCoords(1, countDoors), doorCoords(2, countDoors));
end




end