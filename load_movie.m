function texids = load_movie(movie_name, win)

movie = Screen('OpenMovie', win, movie_name, 4, 4, 2);

% We run playback at 100x the normal speed, non-looped, without sound:
Screen('PlayMovie', movie, 100, 0, 0);

% Movie to texture conversion loop:
movietexture=1;     % Texture handle for the current movie frame.
count=1;
while movietexture>=0
    [movietexture pts] = Screen('GetMovieImage', win, movie, 1);
    texids(count) = movietexture;
    count = count + 1;
end

% Stop "playback":
Screen('PlayMovie', movie, 0, 0, 0);

% Close movie:
Screen('CloseMovie', movie);


end