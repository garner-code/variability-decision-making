function fixRects = define_fix_rects(backRect, xCenter, yCenter, fixPix)
% function to draw 9 doors on the background square provided in backRect
% will work if backRect is placed in the centre by draw_background.m
% get coordinates of background Rect
centeredRect = CenterRectOnPointd(backRect, xCenter, yCenter);
xPix = centeredRect(3) - centeredRect(1);
yPix = centeredRect(4) - centeredRect(2);
squareXpos = centeredRect(1)+  [xPix*0.25, xPix*0.5, xPix*.75];
squareYpos = centeredRect(2) + [yPix*0.25, yPix*0.5, yPix*.75];
fixCoords = combvec(squareXpos, squareYpos);

fixBase = [0 0 fixPix, fixPix];
% make rectangle coordinates
fixRects = nan(4,9);
for countLocs = 1:size(fixRects,2)
    fixRects(:, countLocs) = CenterRectOnPointd(fixBase, fixCoords(1, countLocs), fixCoords(2, countLocs));
end
end