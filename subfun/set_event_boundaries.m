function [frames, frame2print] = set_event_boundaries(texids, win, win_w, win_h, opt, make_screen_capture, screen_capture_filename, frame2print)

frames = NaN;

drawn_circles = 0;

oval_radius = win_w/75;

line_height = win_h*19/20;

circle_color = [
    255 0 0;
    0 0 255];

count = numel(texids);

currentindex = 1;

SetMouse(0, win_h)

while 1
    
    x = GetMouse;
    
    if currentindex <= 0 
        currentindex = 1;
    end
    
    if currentindex > count-1
        currentindex = count-2;
    end
    
    oval_rect = get_oval_rect(x, oval_radius, line_height);
    
    
    % Draw texture 'currentindex'
    Screen('DrawTexture', win, texids(currentindex));

    Screen('DrawLine', win , [0 0 0], 0, line_height, win_w, line_height, 4);
    
    Screen('FillOval', win, [0 0 0], oval_rect);
    
    
    % Add selected frames
    if ~isnan(frames)
        if numel(frames)>2 || [numel(unique(frames))==1 && numel(frames)>1]
            frames = NaN;
            drawn_circles = 0;
        end
        for i_oval = 1:numel(frames)
            oval_rect = get_oval_rect(frames(i_oval), oval_radius*1.2, line_height);
            Screen('FillOval', win, circle_color(i_oval,:), oval_rect);
        end
    end

    
    % Show drawn stuff
    Screen('Flip', win);
    if make_screen_capture
        frame2print = print_screen(win, screen_capture_filename, frame2print);
    end
    
    
    % Get mouse info and update info to display
    [x, ~, buttons] = GetMouse;
    
    currentindex = round(x/win_w*count);
    
    % collect clicked frames 
    if any(buttons) && x~=frames(end)
        drawn_circles = drawn_circles + 1;
        frames(drawn_circles) = x;
        clear buttons x
    end
    

    % Check for key press to get out
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        
        if (keyCode(opt.esc))
            frames = 666;
            break
        end

        if (keyCode(opt.return)) && numel(frames)==2
            break
        end

    end

end

% for output
frames = round(frames/win_w*count);

end

function oval_rect = get_oval_rect(x, oval_radius, line_height)
    oval_rect = [...
        x - oval_radius, ...
        line_height - oval_radius, ...
        x + oval_radius, ...
        line_height + oval_radius];
end