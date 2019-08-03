nb_subjects = 21;

mid_frame = 50;

Answer = 'lorem ipsum';

videos_list = get_videos_list(0);
nb_videos = numel(videos_list);

mid_event_list = round(randn(nb_videos,1) * 5 + mid_frame);

i_row = 1;

for i_subj = 1:nb_subjects
    
    time_stamp = sprintf('20190704T00%02.0f00', i_subj);
    
    trial_list = randperm(nb_videos);

    switch mod(i_subj,3)
        case 0
            subj_grp = 3;
        case 1
            subj_grp = 1;
        case 2
            subj_grp = 2;
    end
    
    question_type_list = get_participant_grp(subj_gr);
    
    for i_video = 1:(nb_videos)
        
        condition = question_type_list(trial_list(i_video));
        videoname = videos_list{trial_list(i_video)};
        
        if condition=='I'
            VideoType='filler';
        else
            VideoType='experimental';
        end
        
        mid_event_list
        
        frames(1)
        
        output(i_row).TimeStamp = time_stamp;
        output(i_row).List = ['P' subj_grp];
        output(i_row).Participant = num2str(i_subj);
        output(i_row).TrialNumber = trial_list(i_video);
        output(i_row).VideoName = data(i_trial).videoname;
        output(i_row).Condition = condition;
        
        
        output(i_row).Answer = Answer;
        output(i_row).VideoType = VideoType;
        
        
        
        
        
        output(count).Start = frames(1);
        output(count).End = frames(2);
        output(count).QRT1 = RT_question_1;
        output(count).QRT2 = RT_question_2;

        
        i_row = i_row+1;
    end
    
end

