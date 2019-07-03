function [response_text] = type_answer(instruction_text, win, win_w, win_h, response_box, opt)

response_text = [];

dst_rect = [...
    win_w/2 - win_w/4 ...
    win_h/2 - win_h/4 ...
    win_w/2 + win_w/4 ...
    win_h/2 + win_h/4];

DrawFormattedText(win, ...
    instruction_text, ...
    'center' , win_h/5, opt.text_color);

Screen('FrameRect', win, opt.text_color, ...
    dst_rect, ...
    2);

Screen('Flip', win);

[response_text, terminatorChar] = ...
    GetEchoString(win, [instruction_text '\n\n'], ...
    win_w/4, win_h/4, opt.text_color, opt.background, 0, response_box, dst_rect, win_h);

end