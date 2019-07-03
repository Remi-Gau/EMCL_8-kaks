function [frames] = set_event_boundaries(texids, win, win_w, win_h, opt)

frames = [NaN];

drawn_circles = 0;

oval_radius = win_w/75;

count = numel(texids);

currentindex = 1;

SetMouse(0, win_h)
x = GetMouse;

while 1
    
    if currentindex <= 0 
        currentindex = 1;
    end
    
    if currentindex > count-1
        currentindex = count-2;
    end
    
    oval_rect = get_oval_rect(x, oval_radius, win_h);
    
    % Draw texture 'currentindex'
    Screen('DrawTexture', win, texids(currentindex));

    Screen('DrawLine', win , [0 0 0], 0, win_h*4/5, win_w, win_h*4/5, 4);
    
    Screen('FillOval', win, [0 0 0], oval_rect);
    
    % Add selected frames
    if ~isnan(frames)
        for i_oval = 1:numel(frames)
            oval_rect = get_oval_rect(frames(i_oval), oval_radius*1.2, win_h);
            Screen('FillOval', win, [0 0 255], oval_rect);
        end
    end

    % Show drawn stuff
    Screen('Flip', win);
    
    
    % Get mouse info and update info to display
    [x, ~, buttons] = GetMouse;
    
    currentindex = round(x/win_w*count);
    
    % collect clicked frames
    if numel(frames)<2
        if any(buttons) && x~=frames(end)
            drawn_circles = drawn_circles + 1;
            frames(drawn_circles) = x; 
        end
    end

    % Check for key press to get out
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

frames = round(frames/win_w*count);

end

function oval_rect = get_oval_rect(x, oval_radius, win_h)
    oval_rect = [...
        x - oval_radius, ...
        win_h*4/5 - oval_radius, ...
        x + oval_radius, ...
        win_h*4/5 + oval_radius];
end