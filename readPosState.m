function result = readPosState(fname)
    fid = fopen(fname); 
    header = fgets(fid);

    deltatime = [];
    setPoint = [];
    procVal = [];
    procValDot = [];
    myerror = [];
    propCoeff = 0;

    while(~feof(fid))
        line = fgets(fid);
        % nsecs 6. pac0pac1pdc-9-10-11, 

        mysplit = split(line, ',');
        nsecval = mysplit(6);
        deltatime=[deltatime (str2double(cell2mat(nsecval)))];
        setPoint=[setPoint (str2double(cell2mat(mysplit(8))))];
        procVal=[procVal (str2double(cell2mat(mysplit(9))))];
        procValDot=[procValDot (str2double(cell2mat(mysplit(10))))];
        myerror=[myerror (str2double(cell2mat(mysplit(11))))];
        propCoeff=str2double(cell2mat(mysplit(14)));
    end
    fclose(fid);
    result = {};
    result{1} = deltatime;
    result{2} = setPoint;
    result{3} = procVal;
    result{4} = procValDot;
    result{5} = myerror;
    result{6} = propCoeff;