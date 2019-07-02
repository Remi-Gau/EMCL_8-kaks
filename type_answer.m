function [response_text] = type_answer(instruction_text, win, response_box, opt)

KbQueueCreate(response_box);
KbQueueStart(response_box);

response_text = [];
% instruction_text = 'Type your answer and press ENTER when finished.   ';

DrawFormattedText(win, ...
    [instruction_text response_text], ...
    'center' , 'center' , opt.text_color);
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
            [instruction_text response_text], ...
            'center' , 'center' , opt.text_color);
        Screen('Flip', win);

    end
    
end
KbQueueRelease(response_box);

end