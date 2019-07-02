function clean_up(response_box)
    KbQueueRelease(response_box);
%     ListenChar()   
    ShowCursor;
    fclose('all');
    sca;
    clear Screen;
end