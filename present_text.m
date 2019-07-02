function [instruction_onset, RT] = present_text(instruction, win, response_box, opt)

KbQueueCreate(response_box);
KbQueueStart(response_box);

DrawFormattedText(win, instruction, 'center', 'center', opt.text_color);

instruction_onset = Screen('Flip', win);

while 1
    
    [pressed, first_press] = KbQueueCheck(response_box);

    if pressed
        
        time_secs = first_press(find(first_press));
        key_code = min(find(first_press));

        if first_press(opt.next)
            RT = 666;
            break
        end

        if first_press(opt.esc)
            RT = 666;
            return
        end
        
    end
    
end
KbQueueRelease(response_box);


RT = time_secs - instruction_onset;
end