addpath(fullfile(pwd, 'subfun'))

opt.background = 255; % black background
opt.text_color = 0; % white text

PsychDebugWindowConfiguration

screen_ID = max(Screen('Screens'));
[win, win_rect] = Screen('OpenWindow', screen_ID, opt.background);
win_w = (win_rect(3) - win_rect(1));
win_h = (win_rect(4) - win_rect(2));

dst_rect = [...
    win_w/20 - 30 ...
    win_h/4 - 30 ...
    win_w*19/20 + 30 ...
    win_h*3/4 + 30 ]


AssertOpenGL;

KbName('UnifyKeyNames');
[keyboard_numbers, keyboard_names] = GetKeyboardIndices;
response_box = min(keyboard_numbers);

[response_text, terminatorChar] = ...
    GetEchoString(win, 'type: ', ...
    win_w/20, win_h/4, opt.text_color, opt.background, 0, dst_rect);

clean_up(response_box)