function [] = draw_mts_tgts(window, edgeRect, backRect, ...
    edgeCol, backCol, doorRects, doorCol,...
    xCenter, yCenter, tgtLocs, memTex, trial_start)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw doors with memory targets
    context_on = GetSecs;
    draw_edge(window, edgeRect, xCenter, yCenter, edgeCol, trial_start, context_on);
    draw_background(window, backRect, xCenter, yCenter, backCol);
    draw_doors(window, doorRects, doorCol);
    im_rects = doorRects(:, tgtLocs);
    Screen('DrawTextures', window, memTex, [], im_rects);
end