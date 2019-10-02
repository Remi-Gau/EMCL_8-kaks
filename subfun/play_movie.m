function play_movie(movie_name, win)

movie = Screen('OpenMovie', win, movie_name);

% Start playback engine:
Screen('PlayMovie', movie, 1);
% Playback loop: Runs until end of movie
while 1
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, movie);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    end
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    % Update display:
    Screen('Flip', win);
    % Release texture:
    Screen('Close', tex);
end
% Stop playback:
Screen('PlayMovie', movie, 0);
% Close movie:
Screen('CloseMovie', movie);

end