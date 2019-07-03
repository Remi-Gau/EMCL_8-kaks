clear;
clc;
sca;

language = 'estonian';

source_folder = fullfile(pwd, 'inputs');

opt.background = 0; % black background

opt.text_color = 255; % white text
opt.font = 'Arial';
opt.fontsize = 40;

opt.dur_fix_cross = 1;

Screen('Preference', 'SkipSyncTests', 1)
PsychDebugWindowConfiguration

% try

%% load texts
[instructions, questions] = text_input(language);


%% Keyboard

% Switch KbName into unified mode: It will use the names of
% the OS-X platform on all platforms in order to make this script portable:
KbName('UnifyKeyNames');

ListenChar(0)

[keyboard_numbers, keyboard_names] = GetKeyboardIndices;
response_box = min(keyboard_numbers); % For key presses for the

% Defines keys
opt.esc = KbName('ESCAPE');
opt.return = KbName('return'); 
opt.right = KbName('RightArrow');
opt.left = KbName('LeftArrow');


%% Screen init
% Choosing the display with the highest display number
% is a best guess about where you want the stimulus displayed.
% Usually there will be only one screen with id = 0,
% unless you use a multi-display setup.
screen_ID = max(Screen('Screens'));

% Open 'windowrect' sized window on screen
[win win_rect] = Screen('OpenWindow', screen_ID, opt.background);

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
[instruction_onset, RT] = present_text(instructions.general, win, response_box, opt);
if RT==666
    clean_up(response_box)
    return
end

WaitSecs(1)



%% Start
StartExpTime = GetSecs;



%% Trial


movie_name = 'D:\github\EMCL_8-kaks\inputs\videos\CATCH.mp4';
question = 'What did the BOY do?';


% draw fixation at beginning of experiment
DrawFormattedText(win, '+', 'center' , 'center' , opt.text_color);
Screen('Flip', win);
WaitSecs(opt.dur_fix_cross)


% Question
[instruction_onset, RT] = present_text(question, win, response_box, opt);
if RT==666
    clean_up(response_box);
    return
end


% Show movie
play_movie(movie_name, win);


% Question
[instruction_onset, RT] = present_text(question, win, response_box, opt);
if RT==666
    clean_up(response_box);
    return
end


% Type answer
instruction_text = 'Type your answer and press ENTER when finished.   ';
[response_text] = type_answer(instruction_text, win, response_box, opt);


% Boundary question
DrawFormattedText(win, 'Now mark the beginning and the end of this event.\n\n\nLOADING...',...
    'center' , 'center' , opt.text_color);
Screen('Flip', win);


% Load movie
texids = load_movie(movie_name, win);


% Browse and Draw loop:
count = numel(texids);
currentindex=1;


while(count>0)
    % Draw texture 'currentindex'
%     Screen('DrawTexture', win, texids(currentindex), srcRect, dstRect);
    Screen('DrawTexture', win, texids(currentindex));

    % Draw some help text:
    [x, y]=Screen('DrawText', win, ...
        'Now mark the beginning and the end of this event\n\n Press left / right cursor key to navigate in movie, ESC to exit.',...
        10, 40, 0);
    
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