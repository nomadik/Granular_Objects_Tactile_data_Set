function mymainresult = executeForPath(dirname, vel)
    disp(sprintf('reading directory %s, with velocity type %d', dirname, vel));
    pacfull0trials = {};
    pac0trials = {};
    pac1trials = {};
    electrials = {};
    origpdc = {};
    origspdot = {};
    label = dirname;
    veldir = sprintf('\\grasp_palm_down_v%d\\', vel);
    fnametempl = '%s\\%s\\_slash_rh_slash_tactile.csv';
    posControllerTemplate = "%s%s_slash_sh_rh_%s_position_controller_slash_state.csv";

    names = {"ffj0", "ffj3", "mfj0", "mfj3", "rfj0", "rfj3", "lfj0", "lfj3", "thj4", "thj5"};

    disp('reading tactile data');
    [tactileTime, pac0_1, pac0_2, pac0_3, pac0_4, pac0_5, ...
        pac1_1, pac1_2, pac1_3, pac1_4, pac1_5, ...
        pdc_1, pdc_2, pdc_3, pdc_4, pdc_5, ...
        elec1, elec2, elec3, elec4, elec5] = readTactile(sprintf(fnametempl, dirname, veldir));
    %%
    counter = 1;
    posStates0 = {};
    posStates3 = {};
    disp('reading position data');
    for i=1:2:10
        %[deltatime, setPoint, procVal, procValDot, myerror, propCoeff]
        posStates0{counter} = [readPosState(sprintf(posControllerTemplate, dirname, veldir, names{i}))];
        posStates3{counter} = [readPosState(sprintf(posControllerTemplate, dirname, veldir, names{i+1}))];
        counter = counter + 1;
    end
    % auto trials extraction
    pacs0 = {};
    pacs0{1} = pac0_1;
    pacs0{2} = pac0_2;
    pacs0{3} = pac0_3;
    pacs0{4} = pac0_4;
    pacs0{5} = pac0_5;
    pacs1 = {};
    pacs1{1} = pac1_1;
    pacs1{2} = pac1_2;
    pacs1{3} = pac1_3;
    pacs1{4} = pac1_4;
    pacs1{5} = pac1_5;
    pdcs = {};
    pdcs{1} = pdc_1;
    pdcs{2} = pdc_2;
    pdcs{3} = pdc_3;
    pdcs{4} = pdc_4;
    pdcs{5} = pdc_5;
    elecs = {};
    elecs{1} = elec1;
    elecs{2} = elec2;
    elecs{3} = elec3;
    elecs{4} = elec4;
    elecs{5} = elec5;
    
    allpathdata{1} = pacs0;
    allpathdata{2} = pacs1;
    allpathdata{3} = pdcs;
    allpathdata{4} = elecs;
    allpathdata{5} = posStates3;
    
    disp('extracting features');
    for myfingind=1:numel(posStates3)
        disp(sprintf('reading finger number %d', myfingind));
        myfingerdata = posStates3{myfingind};
        deltaTJ3_F1 = myfingerdata{1};
        setPointJ3_F1 = myfingerdata{2};
        procValJ3_F1 = myfingerdata{3};
        procValDotJ3_F1 = myfingerdata{4};
        errValsJ3_F1 = myfingerdata{5};
        velJ3_F1 = myfingerdata{6}; 

        % setPointJ3_F1 pdc_1 procValDotJ3_F1
        [pacfull0datatrials, pac0datatrials, pac1datatrials, elecdatatrials, myorigpdc, myorigspdot, myextractedranges] = getTrialsData(setPointJ3_F1, procValDotJ3_F1, pdcs{myfingind},...
            pacs0{myfingind}, pacs1{myfingind}, elecs{myfingind}, dirname, vel, myfingind);
        pacfull0trials{myfingind} = pacfull0datatrials;
        pac0trials{myfingind} = pac0datatrials;
        pac1trials{myfingind} = pac1datatrials;
        electrials{myfingind} = elecdatatrials;
        origpdc{myfingind} = myorigpdc;
        origspdot{myfingind} = myorigspdot;
        myranges{myfingind} = myextractedranges;
    end 
    mymainresult = {};
    mymainresult{1} = pac0trials;
    mymainresult{2} = pac1trials;
    mymainresult{3} = electrials;
    mymainresult{4} = label;
    mymainresult{5} = vel;
    mymainresult{6} = origpdc;
    mymainresult{7} = origspdot;
    mymainresult{8} = allpathdata;
    mymainresult{9} = myranges;
    mymainresult{10} = pacfull0trials;
    
    disp('done for current path');