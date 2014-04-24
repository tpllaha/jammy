function y = read_beat(filename, delimiter, track)
    data = read_mixed_csv(filename,delimiter);
    divisions = data(1,6); % number of divisions per quarter note
    rate = 4/str2double(char(divisions)); % rate of conversion between midi time and network 
                        % time
    d = data(char(data(:,1)) == int2str(track),:);
    timesteps = rate*str2double(d(end,2));
    y = zeros(1,    timesteps);
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

        start = round(rate*(str2double(char(d(i,2))))) + 1;
        note = str2double(char(d(i,5)));
        
        if note < y(start)
            i = i+1;
            continue;
        end
        y(start) = note;
        
        i = i+1;   
    end
end