function y = write_notes(fname,division,leadNotes,leadDur,accompNotes,accompDur)
   fd = fopen(fname,'wt');
    
    rate = division/4;
    totalTime = size(leadNotes,2)*rate;
    
    % Accompanying track
    fprintf(fd, '0, 0, Header, %d, %d, %d\r\n', 1,2,division);
    fprintf(fd, '1, 0, Start_track, , , \r\n');
    fprintf(fd, '1, 0, Title_t, Fingered Bass, , \r\n');
    fprintf(fd, '1, 0, Control_c, 1, 0, 0\r\n');
    fprintf(fd, '1, 0, Control_c, 1, 32, 0\r\n');
    
    fprintf(fd, '1, 0, Program_c, 1, 33\r\n'); % Bass
    
    %fprintf(fd, '1, 0, Control_c, 1, 10, 64\r\n');
    %fprintf(fd, '1, 0, Control_c, 1, 93, 0\r\n');
    %fprintf(fd, '1, 0, Control_c, 1, 7, 100\r\n');
    %fprintf(fd, '1, 0, Control_c, 1, 91, 0\r\n');
    %fprintf(fd, '1, 0, Control_c, 1, 64, 0\r\n');
    %fprintf(fd, '1, 0, Control_c, 1, 91, 52\r\n');
    %fprintf(fd, '1, 0, Control_c, 1, 10, 70\r\n');
    %fprintf(fd, '1, 0, Control_c, 1, 7, 95\r\n');
    i = 1;
    while (i <= size(accompNotes,2))
        time = round(rate*(i-1));
        note = accompNotes(i);
        if note ~= 0
            fprintf(fd, '1, %d, Note_on_c, 1, %d, 40\r\n', time, note);
        end
        i = i + accompDur(i);
        time = round(rate*(i-1));
        if note ~= 0
            fprintf(fd, '1, %d, Note_off_c, 1, %d, 0\r\n', min(time,totalTime), note);
        end
    end
    fprintf(fd,'1, %d, End_track, , , \r\n', totalTime);

    % Leading track
    fprintf(fd, '2, 0, Start_track, , , \r\n');
    fprintf(fd, '2, 0, Title_t, Electric Guitar, , \r\n');
    fprintf(fd, '2, 0, Control_c, 2, 0, 0\r\n');
    fprintf(fd, '2, 0, Program_c, 2, 1,\r\n'); % Piano
    %fprintf(fd, '2, 0, Control_c, 2, 10, 64\r\n');
    %fprintf(fd, '2, 0, Control_c, 2, 93, 0\r\n');
    %fprintf(fd, '2, 0, Control_c, 2, 7, 100\r\n');
    %fprintf(fd, '2, 0, Control_c, 2, 91, 0\r\n');
    %fprintf(fd, '2, 0, Control_c, 2, 64, 0\r\n');
    %fprintf(fd, '2, 0, Control_c, 2, 91, 48\r\n');
    %fprintf(fd, '2, 0, Control_c, 2, 10, 51\r\n');
    %fprintf(fd, '2, 0, Control_c, 2, 7, 100\r\n');
    i = 1;
    while (i <= size(leadNotes,2))
        time = round(rate*(i-1));
        note = leadNotes(i);
        if note ~= 0
            fprintf(fd, '2, %d, Note_on_c, 2, %d, 50\r\n', time, note);
        end
        i = i + leadDur(i);
        time = round(rate*(i-1));
        if note ~= 0
            fprintf(fd, '2, %d, Note_off_c, 2, %d, 0\r\n', min(time,totalTime), note);
        end
    end
    fprintf(fd,'2, %d, End_track, , , \r\n', totalTime);
    
    fprintf(fd,'0, 0, End_of_file, , , \r\n');
        
    y = fclose(fd);
    
end


