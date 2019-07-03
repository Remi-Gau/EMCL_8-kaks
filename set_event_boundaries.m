function set_event_boundaries(texids, win, opt)

% Browse and draw loop:
count = numel(texids);
currentindex=1;

while(count>0)
    % Draw texture 'currentindex'
    Screen('DrawTexture', win, texids(currentindex));

    % Show drawn stuff:
    Screen('Flip', win);

    % Check for key press:
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if (keyCode(opt.esc))
            clean_up(response_box)
            return
        end

        if (keyCode(opt.return))
            break
        end

        if (keyCode(opt.right) && currentindex<count)
            % One frame forward:
            currentindex=currentindex+1;
        end
        if (keyCode(opt.left) && currentindex>1)
            % One frame backward:
            currentindex=currentindex-1;
        end

        % Wait for key-release:
        KbReleaseWait;
    end

end



end