
json_content.TimeStamp = {'1', 'time stamp from filename'};
json_content.List = {'2', 'integer from 1 to 3'};
json_content.Participant = {'3', 'string'};
json_content.TrialNumber = {'4', 'integer from 1 to 12'};
json_content.VideoName = {'5', 'string'};
json_content.Condition = {'6', 'A P N I'};
json_content.Start = {'7', 'start frame: integer from 1 to 12'};
json_content.End = {'8', 'end frame: integer from 1 to 12'};
json_content.QRT1 = {'9', 'RT to first question'};
json_content.QRT2 = {'10', 'RT to second question'};
json_content.Answer = {'11', 'string'};
json_content.VideoType = {'12', 'experimental VS filler'};


json_filenname = fullfile(pwd, 'EMCL_8_kaks_datadict.json');
json_options.indent = '    ';
jsonwrite(json_filenname, json_content, json_options)