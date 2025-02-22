function [points, tgt_on] = draw_mts_tgts(window, edgeRect, backRect, ...
    edgeCol, backCol, doorRects, doorCol,...
    xCenter, yCenter, tgtLocs, tgtIDs, trial_start)
% this function gets the 3 targets from tgtIDs and draws them in tgtLocs
tex = [];
for i = 1:length(tgtIDs)
    
    image_num = tgtIDs(i);
    if image_num < 10
        if exist(sprintf('mts-tgts/tgt0%d.jpeg', image_num))
            im_fname = sprintf('mts-tgts/tgt0%d.jpeg', image_num);
        else
            im_fname = sprintf('mts-tgts/tgt0%d.jpg', image_num);
        end
    else
        if exist(sprintf('mts-tgts/tgt%d.jpeg', image_num))
            im_fname = sprintf('mts-tgts/tgt%d.jpeg', image_num);
        else
            im_fname = sprintf('mts-tgts/tgt%d.jpg', image_num);
        end
    end

    im = imread(im_fname);
    tex(i) = Screen('MakeTexture', window, im);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw doors with target
context_on = GetSecs;
draw_edge(window, edgeRect, xCenter, yCenter, edgeCol, trial_start, context_on);
draw_background(window, backRect, xCenter, yCenter, backCol);
draw_doors(window, doorRects, doorCol);
im_rects = doorRects(:, tgtLocs);
Screen('DrawTextures', window, tex, [], im_rects);
% draw targets
tgt.vbl = Screen('Flip', window);
tgt_on = tgt.vbl;
end