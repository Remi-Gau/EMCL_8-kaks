function [frame2print] = flip_screen(win, make_screen_capture, filename, frame2print)

Screen('Flip', win);

if make_screen_capture
    frame2print = print_screen(win, filename, frame2print);
end

end