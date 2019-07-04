clear
clc

output_folder = fullfile(pwd, 'ouputs');

output_csv = fullfile(output_folder, 'EMCL_8_kaks.tsv');

file_ls = dir(fullfile(output_folder, 'comp-*.mat'));

% output.TimeStamp = {};
% output.List = {};
% output.Participant = {};
% output.TrialNumber = {};
% output.VideoName = {};
% output.Condition = {};
% output.Start = {};
% output.End = {};
% output.QRT1 = {};
% output.QRT2 = {};
% output.Answer = {};
% output.VideoType = {};

count = 1;


%% Get data

SubNb = 0;

for i_file = 1:numel(file_ls)
    
    if ~contains(file_ls(i_file).name, 'training')

        load(fullfile(output_folder, file_ls(i_file).name), ...
            'subj_grp', 'comp_prefix', 'subj_id', 'data')
        
        if isnan(subj_id)
            subj_id = 'NaN';
        elseif isnumeric(subj_id)
            subj_id = num2str(subj_id);
        end
        
        for i_trial = 1:numel(data)
            
            if data(i_trial).condition=='I'
                VideoType='filler';
            else
                VideoType='experimental';
            end
            
            time_stamp_idx = strfind(file_ls(i_file).name, '2019');
            
            output(count).TimeStamp = file_ls(i_file).name(time_stamp_idx:end-4); %#ok<*SAGROW>
            output(count).List = ['P' subj_grp];
            output(count).Participant = ['c-' comp_prefix '_sub-' subj_id];
            output(count).TrialNumber = i_trial;
            output(count).VideoName = data(i_trial).videoname;
            output(count).Condition = data(i_trial).condition;
            output(count).Start = data(i_trial).frames(1);
            output(count).End = data(i_trial).frames(2);
            output(count).QRT1 = data(i_trial).RT_question_1;
            output(count).QRT2 = data(i_trial).RT_question_2;
            output(count).Answer = data(i_trial).response_text;
            output(count).VideoType = VideoType;
            
            count = count+1;
        end
        
    end
end

%% Write CSV

headers = {
    'TimeStamp'
    'List'
    'Participant'
    'TrialNumber'
    'VideoName'
    'Condition'
    'Start'
    'End'
    'QRT1'
    'QRT2'
    'Answer'
    'VideoType'
    };

fid = fopen(output_csv, 'w');

for i_header = 1:numel(headers)
    fprintf (fid, '%s\t', headers{i_header});
end
fprintf (fid, '\n');

for i_row = 1:(count-1)
    
    fprintf (fid, '%s\t', output(i_row).TimeStamp);
    fprintf (fid, '%s\t', output(i_row).List);
    fprintf (fid, '%s\t', output(i_row).Participant);
    fprintf (fid, '%i\t', output(i_row).TrialNumber);
    fprintf (fid, '%s\t', output(i_row).VideoName);
    fprintf (fid, '%s\t', output(i_row).Condition);
    fprintf (fid, '%i\t', output(i_row).Start);
    fprintf (fid, '%i\t', output(i_row).End);
    fprintf (fid, '%f\t', output(i_row).QRT1);
    fprintf (fid, '%f\t', output(i_row).QRT2);
    fprintf (fid, '%s\t', output(i_row).Answer);
    fprintf (fid, '%s\t', output(i_row).VideoType);

    fprintf (fid, '\n');
    
end

fclose (fid);




