clear;
clc;
sca;

language = 'estonian';

debug = 1;
training = 1;

opt.background = 255; % black background

opt.text_color = 0; % white text
opt.font = 'Arial';
opt.fontsize = 40;

opt.dur_fix_cross = 1;


%% Set Folder
source_folder = fullfile(pwd, 'inputs');
output_folder = fullfile(pwd, 'ouputs');
[~, ~, ~] = mkdir(output_folder);


%%
if debug
    PsychDebugWindowConfiguration
else
    Screen('Preference', 'SkipSyncTests', 1)
end

% try

%% load instructions, question list, video list
[instructions, questions] = text_input(language);

[videos_list] = get_videos_list(training);

nb_videos = numel(videos_list);


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


%% Screen init
% Choosing the display with the highest display number
% is a best guess about where you want the stimulus displayed.
% Usually there will be only one screen with id = 0,
% unless you use a multi-display setup.
screen_ID = max(Screen('Screens'));

% Open 'windowrect' sized window on screen
[win, win_rect] = Screen('OpenWindow', screen_ID, opt.background);

win_w = (win_rect(3) - win_rect(1));
win_h = (win_rect(4) - win_rect(2));

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
if training
    
    instruction = [];
    for i_line = 1:size(instructions.general)
        instruction = [instruction instructions.general{i_line} '\n\n']; %#ok<AGROW>
    end
    
    [RT] = present_text(instruction, win, response_box, opt);
    if RT==666
        clean_up(response_box)
        return
    end
    
end

WaitSecs(1)



%% Start
StartExpTime = GetSecs;



%% Trial

for i_vid = 1:nb_videos
    
    %  get trial info
    
    if training
        trial_type = 2;
        question_type = 'N';
    end
    
    trial_type = 1;
    
    switch trial_type
        case 1 % critical
            question_type = 'N'; %Neutral / Agent / Patient
        case 0 % instrument
            question_type = 'I';
        case 2 % training
            question_type = 'T';
    end
    
    switch question_type
        case 'A'
            question = questions.agent{1};
        case 'N'
            question = questions.neutral{1};
        case 'I'
            question = questions.instrument{1};
        case 'P'
            question = questions.patient{1};
    end
    
    
    % Get fullpath of movie name
    movie_name = fullfile(source_folder, 'videos');
    if training
        movie_name = fullfile(movie_name, 'training');
    elseif trial_type==0
        movie_name = fullfile(movie_name, 'instruments');
    end
    movie_name = fullfile(movie_name, [videos_list{i_vid} '.mp4']);
    
    
    % Load movie
    DrawFormattedText(win, 'Katse algab hetke pärast.',...
        'center' , 'center' , opt.text_color);
    Screen('Flip', win);
    texids = load_movie(movie_name, win);
    
    
    % draw fixation at beginning of experiment
    DrawFormattedText(win, '+', 'center' , 'center' , opt.text_color);
    Screen('Flip', win);
    WaitSecs(opt.dur_fix_cross)
    
    
    % Question
    [RT_question_1] = present_text(question, win, response_box, opt);
    if RT_question_1==666
        clean_up(response_box);
        return
    end
    
    
    % Show movie
    play_movie(movie_name, win);
    
    
    % Question
    [RT_question_2] = present_text(question, win, response_box, opt);
    if RT_question_2==666
        clean_up(response_box);
        return
    end
    
    
    % Type answer
    instruction_text = 'Sisesta oma vastus esitatud küsimusele ja vajuta ENTER.' ;
    [response_text] = type_answer(instruction_text, win, win_w, win_h, response_box, opt);
    
    
    % Boundary question
    instruction = [];
    for i_line = 1:size(instructions.boundary)
        instruction = [instruction instructions.boundary{i_line} '\n\n']; %#ok<AGROW>
    end
    present_text(instruction, win, response_box, opt);
    
    
    % Set boundary of the event
    frames = set_event_boundaries(texids, win, win_w, win_h, opt);
    if frames==666
        clean_up(response_box);
        return
    end
    
    clear texids
    
end


%% Finish

WaitSecs(1)

DrawFormattedText(win, 'Aitäh katses osalemise eest!', ...
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