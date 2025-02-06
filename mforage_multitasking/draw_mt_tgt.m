function [] = draw_mt_tgt(window, doorRects, ...
                           didx, image_num)

if image_num < 10
    if exist(sprintf('tgt0-100/tgt0%d.jpeg', image_num))
        im_fname = sprintf('tgt0-100/tgt0%d.jpeg', image_num);
    else
        im_fname = sprintf('tgt0-100/tgt0%d.jpg', image_num);
    end
else
    if exist(sprintf('tgt0-100/tgt%d.jpeg', image_num))
        im_fname = sprintf('tgt0-100/tgt%d.jpeg', image_num);
    else
        im_fname = sprintf('tgt0-100/tgt%d.jpg', image_num);
    end
end

im = imread(im_fname);
tex = Screen('MakeTexture', window, im);
im_rect = doorRects(:, didx);
Screen('DrawTexture', window, tex, [], im_rect);

end