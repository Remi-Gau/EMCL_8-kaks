function question_type_list = get_participant_grp(subj_gr)
switch subj_gr
    case 1
        question_type_list = {
            'P'
            'P'
            'A'
            'A'
            'N'
            'N'
            'I'
            'I'
            'I'
            'I'
            'I'
            'I'
            };
    case 2
        question_type_list = {
            'A'
            'A'
            'N'
            'N'
            'P'
            'P'
            'I'
            'I'
            'I'
            'I'
            'I'
            'I'
            };
    case 3
        question_type_list = {
            'N'
            'N'
            'P'
            'P'
            'A'
            'A'
            'I'
            'I'
            'I'
            'I'
            'I'
            'I'
            };
        
end
end