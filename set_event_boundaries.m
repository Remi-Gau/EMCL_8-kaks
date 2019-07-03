function [frames] = set_event_boundaries(texids, win, win_w, win_h, opt)

frames = [];

oval_radius = win_w/75;

count = numel(texids);

currentindex = 1;

SetMouse(0, win_h)
x = GetMouse;

oval_rect = [...
    x - oval_radius, ...
    win_h*4/5 - oval_radius, ...
    x + oval_radius, ...
    win_h*4/5 + oval_radius];

while 1
    
    if currentindex <= 0 
        currentindex = 1;
    end
    
    if currentindex > count-1
        currentindex = count-2;
    end
    
    
    % Draw texture 'currentindex'
    Screen('DrawTexture', win, texids(currentindex));
    
    texids(currentindex)

    Screen('DrawLine', win , [0 0 0], 0, win_h*4/5, win_w, win_h*4/5, 4);
    
    Screen('FillOval', win, [0 0 0], oval_rect);

    % Show drawn stuff
    Screen('Flip', win);
    
    
    
    [x] = GetMouse;
    
    currentindex = round(x/win_w*count);
    
    oval_rect = [...
        x - oval_radius, ...
        win_h*4/5 - oval_radius, ...
        x + oval_radius, ...
        win_h*4/5 + oval_radius];

    
    % Check for key press:
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        if (keyCode(opt.esc))
            frames = 666;
            break
        end

        if (keyCode(opt.return))
            break
        end

    end

end



end