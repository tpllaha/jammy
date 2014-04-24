% This function takes the file name of a csv file, a delimiter and a track
% number. It returns the the notes of the midi file represented by the csv
% (as converted by midicsv), 
function y = read_notes(filename, delimiter, track)
    data = read_mixed_csv(filename,delimiter);
    divisions = data(1,6); % number of divisions per quarter note
    rate = 4/str2double(char(divisions)); % rate of conversion between midi time and network 
                        % time
    d = data(char(data(:,1)) == int2str(track),:);
    timesteps = rate*str2double(d(end,2));
    y = zeros(2,timesteps);
    i = 1;
    while i < size(d,1)
        while (strcmp(char(d(i,3)),'Note_on_c') == 0)
            i = i+1;
            if i > size(d,1)
                break;
            end
        end
        if i > size(d,1)
            break;
        end
        temp = i;
        start = round(rate*(str2double(char(d(i,2))))) + 1;
        note = str2double(char(d(i,5)));
        if note < y(1,start)
            i = i+1;
            continue;
        end
        while (strcmp(char(d(i,3)), 'Note_off_c') == 0 || str2double(char(d(i,5))) ~= note)
            i = i+1;
            if i > size(d,1)
                break
            end
        end
        if i > size(d,1)
            break
        end
        finish = round(rate*(str2double(char(d(i,2))))) + 1;
        dur = finish - start;
        
            y(1,start:finish-1) = note;
            y(2,start:start + fix(dur/16)*16 - 1) = 16;
            y(2,start + fix(dur/16)*16:start + fix(dur/16)*16 + mod(dur,16)-1) = mod(dur,16);
        
        i = temp+1;     
    end
    i = 1;
    while (i < size(y,2))
        while (y(1,i) ~= 0)
            i = i+1;
            if i >= size(y,2)
                break
            end
        end
        if i> size(y,2)
            break
        end
        start = i;
        while (y(1,i) == 0)
            i = i+1;
            if i >= size(y,2)
                break
            end
        end
        if i > size(y,2)
            break
        end
        finish = i;
        if i == size(y,2)
            finish = i+1;
        end
        dur = finish - start;
        y(2,start:start + fix(dur/16)*16 - 1) = 16;
        y(2,start + fix(dur/16)*16:start + fix(dur/16)*16 + mod(dur,16)-1) = mod(dur,16);
    end
    
end