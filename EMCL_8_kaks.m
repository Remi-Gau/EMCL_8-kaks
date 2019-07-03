clear;
clc;
sca;

subj_id = input('Subject ID? (00 - 99) ','s');
subj_grp = input('Subject group? (1, 2, 3) ','s');
subj_gr = str2double(subj_grp);

language = 'estonian';

debug = 0;
training = 1;

opt.background = 255; % black background

opt.text_color = 0; % white text
opt.font = 'Arial';
opt.fontsize = 40;

opt.dur_fix_cross = 1;

% videos
% V1: Squash
% V4: Catch
% V2: Knock over
% V5: Unhook
% V3: Kick
% V6: Ripoff
% V7: Cut
% V8: Split
% V9: Break
% V10: Pop
% V11: Hit
% V12: Extinguish

video_list_number = [1 4 2 5 3 6 7 8 9 10 11 12];

question_type_list = get_participant_grp(subj_gr);




%% Set Folder
source_folder = fullfile(pwd, 'inputs');
output_folder = fullfile(pwd, 'ouputs');
[~, ~, ~] = mkdir(output_folder);

if training
    output_file = fullfile(output_folder, ...
        ['sub-' subj_id '_grp-' subj_grp '_' datestr(now,'yyyymmddTHHMMSS') '_training.mat']);
else
    output_file = fullfile(output_folder, ...
        ['sub-' subj_id '_grp-' subj_grp '_' datestr(now,'yyyymmddTHHMMSS') '.mat']);
end


%%
if debug
    PsychDebugWindowConfiguration
else
    Screen('Preference', 'SkipSyncTests', 1) %#ok<*UNRCH>
end

% try

%% load instructions, question list, video list
[instructions, questions] = text_input(language);
questions.all = cat(1, questions.patient, questions.instrument);

[videos_list_name] = get_videos_list(training);

nb_videos = numel(videos_list_name);

% shuffle everything
video_list_order = randperm(nb_videos);


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
        instruction = [instruction instructions.general{i_line} '\n\n'];
    end
    
    [RT] = present_text(instruction, win, response_box, opt);
    if RT==666
        clean_up(response_box)
        return
    end
    
end


%% Trial loop

data = [];

for i_trial = 1:nb_videos
    
    %  get trial info
    video = videos_list_name{video_list_order(i_trial)};
    
    if training
        question_type = 'N';
    else
        question_type = question_type_list{video_list_order(i_trial)};
    end
    
    switch question_type
        case 'A'
            question = questions.agent{1};
        case 'N'
            question = questions.neutral{1};
        case 'P'
            question = questions.all{video_list_order(i_trial)};
        case 'I'
            question = questions.all{video_list_order(i_trial)};
    end
    
    
    % Get fullpath of movie name
    movie_name = fullfile(source_folder, 'videos');
    if training
        movie_name = fullfile(movie_name, 'training');
    end
    movie_name = fullfile(movie_name, [video '.mp4']);
    
    disp(movie_name)
    
    % Load movie
    DrawFormattedText(win, 'Katse algab hetke pärast.',...
        'center' , 'center' , opt.text_color);
    Screen('Flip', win);
    texids = load_movie(movie_name, win);
    
    
    % Draw fixation at beginning of experiment
    DrawFormattedText(win, '+', 'center' , 'center' , opt.text_color);
    Screen('Flip', win);
    WaitSecs(opt.dur_fix_cross);
    
    
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
    instruction_text = 'Kirjuta vastus järgmisele ekraanile ja vajuta ENTER';
    present_text(instruction_text, win, response_box, opt);
    [response_text] = type_answer('Vastus:', win, win_w, win_h, response_box, opt);
    Screen('Flip', win);
    
    
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
    
    % Close texture
    Screen('Close', texids)
    clear texids
    
    
    % Save data
    data(i_trial).frames = frames; %#ok<*SAGROW>
    data(i_trial).response_text = response_text;
    data(i_trial).RT_question_1 = RT_question_1;
    data(i_trial).RT_question_2 = RT_question_2;
    
end

save(output_file);


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