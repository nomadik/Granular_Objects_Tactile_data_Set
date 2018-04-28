function result = readPosStateCmd(fname)
    fid = fopen(fname); 
    header = fgets(fid);

    command = [];
    

    while(~feof(fid))
        line = fgets(fid); 
        mysplit = split(line, ','); 
        command=[command (str2double(mysplit{13}))]; 
    end
    fclose(fid);
    result = command;