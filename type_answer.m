function [response_text] = type_answer(instruction_text, win, win_w, win_h, response_box, opt)

response_text = [];

dst_rect = [...
    win_w/2 - win_w/4 ...
    win_h/2 - win_h/4 ...
    win_w/2 + win_w/4 ...
    win_h/2 + win_h/4];

KbQueueCreate(response_box);
KbQueueStart(response_box);

DrawFormattedText(win, ...
    instruction_text, ...
    'center' , win_h/5, opt.text_color);

Screen('FrameRect', win, opt.text_color, ...
    dst_rect, ...
    2);

Screen('Flip', win);

while 1
    
    [pressed, first_press] = KbQueueCheck(response_box);

    if pressed
        
        time_secs = first_press(find(first_press));
        key_code = min(find(first_press));
        key_name = KbName(key_code);
        
        if first_press(opt.return)
            break
        end
        
        if first_press(opt.esc)
            clean_up(response_box)
            return
        end
        
        response_text = [response_text key_name];
        
        
        DrawFormattedText(win, ...
            instruction_text, ...
            'center' , win_h/5, opt.text_color);
        
        Screen('FrameRect', win, opt.text_color, ...
            dst_rect, ...
            2);
        
        DrawFormattedText(win, ...
            response_text, ...
            'center' , 'center', opt.text_color);
        
        Screen('Flip', win);

    end
    
end
KbQueueRelease(response_box);

end