clear;
clc;
sca;

subj_id = input('Subject ID? (00 - 99) ','s');

subj_grp = input('Subject group? (1, 2, 3) ','s');
subj_gr = str2double(subj_grp);

language = 'estonian';

question_type_list = get_participant_grp(subj_gr);


%% load instructions, question list, video list
[instructions, questions] = text_input(language);
questions.all = cat(1, questions.patient, questions.instrument);

[videos_list_name] = get_videos_list(0);

nb_videos = numel(videos_list_name);

% shuffle everything
video_list_order = randperm(nb_videos);


%% Trial loop
for i_trial = 1:nb_videos

    question_type = question_type_list{video_list_order(i_trial)};
    video = videos_list_name{video_list_order(i_trial)};
    
    disp(video_list_order(i_trial))
    disp(video)
    disp(question_type)
    
end





