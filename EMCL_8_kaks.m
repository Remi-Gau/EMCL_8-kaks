clear;
clc;
sca;

opt.background = 0; % black background

opt.text_color = 255; % white text
opt.font = 'Arial';
opt.fontsize = 40;

% Parameters to cut the movies
height = 576;
width = 720;

scale = .8; 

hor_offset = 0;
vert_offset = 0;

opt.dur_fix_cross = 1;

Screen('Preference', 'SkipSyncTests', 1)

PsychDebugWindowConfiguration

% try


%% Keyboard

% Switch KbName into unified mode: It will use the names of
% the OS-X platform on all platforms in order to make this script portable:
KbName('UnifyKeyNames');

ListenChar(0)

[keyboard_numbers, keyboard_names] = GetKeyboardIndices;
response_box = min(keyboard_numbers); % For key presses for the

% Defines keys
opt.esc = KbName('ESCAPE'); % Quit keyCode
opt.return = KbName('return'); % Next kecide
opt.next = KbName('space'); % Next kecide

right=KbName('RightArrow');
left=KbName('LeftArrow');


%% Screen init
% Choosing the display with the highest display number
% is a best guess about where you want the stimulus displayed.
% Usually there will be only one screen with id = 0,
% unless you use a multi-display setup.
screen_ID = max(Screen('Screens'));

% Open 'windowrect' sized window on screen
[win win_rect] = Screen('OpenWindow', screen_ID, opt.background);

win_w = (win_rect(3) - win_rect(1))
win_h = (win_rect(4) - win_rect(2))

srcRect = [0 0 width height];

dstRect = [...
    ((win_w - scale*width)/2) - hor_offset*win_w ...
    ((win_h - scale*height)/2) - vert_offset*win_h ...
    ((win_w + scale*width)/2) - hor_offset*win_w ...
    ((win_h + scale*height)/2) - vert_offset* win_h];

% Child protection: Make sure we run on the OSX / OpenGL Psychtoolbox.
% Abort if we don't:
AssertOpenGL;


ifi = Screen('GetFlipInterval', win);
FrameRate = Screen('FrameRate', screen_ID);
if FrameRate == 0
    FrameRate = 1/ifi;
end

Screen(win, 'TextFont', opt.font);
Screen(win, 'TextSize', opt.fontsize);

Priority(MaxPriority(win));



%% Instruction
instruction = 'Instruction. Press the space bar to move on.';

[instruction_onset, RT] = present_text(instruction, win, response_box, opt);
if RT==666
    clean_up(response_box)
    return
end

WaitSecs(1)



%% Start
StartExpTime = GetSecs;



%% Trial

movie_name = 'D:\github\EMCL_8-kaks\inputs\videos\CATCH.mp4';

% draw fixation at beginning of experiment
DrawFormattedText(win, '+', 'center' , 'center' , opt.text_color);
Screen('Flip', win);
WaitSecs(opt.dur_fix_cross)


% Question 1
question_1 = 'What did the boy do?'
[instruction_onset, RT] = present_text(question_1, win, response_box, opt);
if RT==666
    clean_up(response_box)
    return
end


% Show movie
play_movie(movie_name, win)


% Question 1
question_1 = 'What did the BOY do?'
[instruction_onset, RT] = present_text(question_1, win, response_box, opt);
if RT==666
    clean_up(response_box)
    return
end

% Type answer
response_text = [];
DrawFormattedText(win, ...
    ['Type your answer and press ENTER when finished.' response_text], ...
    'center' , 'center' , opt.text_color);
Screen('Flip', win);

KbQueueCreate(response_box);
KbQueueStart(response_box);
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
            ['Type your answer and press ENTER when finished.  ' response_text], ...
            'center' , 'center' , opt.text_color);
        Screen('Flip', win);

    end
    
end
KbQueueRelease(response_box);

% Boundary question
DrawFormattedText(win, 'Now mark the beginning and the end of this event.\n\n\nLOADING...',...
    'center' , 'center' , opt.text_color);
Screen('Flip', win);


% Boundary marking
[movie] = Screen('OpenMovie', win, movie_name, 4, 4, 2);

% We run playback at 100x the normal speed, non-looped, without sound:
Screen('PlayMovie', movie, 100, 0, 0);

% Movie to texture conversion loop:
movietexture=1;     % Texture handle for the current movie frame.
count=1;
while movietexture>=0
    [movietexture pts] = Screen('GetMovieImage', win, movie, 1);
    texids(count) = movietexture;
    texpts(count) = pts;
    count = count + 1;
end

% Stop "playback":
Screen('PlayMovie', movie, 0, 0, 0);

% Close movie:
Screen('CloseMovie', movie);


% Browse and Draw loop:
currentindex=1;

while(count>0)
    % Draw texture 'currentindex'
%     Screen('DrawTexture', win, texids(currentindex), srcRect, dstRect);
    Screen('DrawTexture', win, texids(currentindex));

    % Draw some help text:
    [x, y]=Screen('DrawText', win, ...
        'Now mark the beginning and the end of this event\n\n Press left / right cursor key to navigate in movie, ESC to exit.',10, 40);
    
    % Show drawn stuff:
    Screen('Flip', win);
    
    % Check for key press:
    [keyIsDown, secs, keyCode]=KbCheck;
    if keyIsDown
        if (keyCode(opt.esc))
            clean_up(response_box)
            return
        end
        
        if (keyCode(opt.next))
            break
        end
        
        if (keyCode(right) && currentindex<count)
            % One frame forward:
            currentindex=currentindex+1;
        end
        if (keyCode(left) && currentindex>1)
            % One frame backward:
            currentindex=currentindex-1;
        end
        
        % Wait for key-release:
        KbReleaseWait;
    end

end


clear texids texpts

DrawFormattedText(win, 'Thank you for your participation.', ...
    'center' , 'center' , opt.text_color);
Screen('Flip', win);

WaitSecs(2)




%% Close
clean_up(response_box)


% catch
%
%     clean_up(response_box)
%     psychrethrow(psychlasterror);
% end