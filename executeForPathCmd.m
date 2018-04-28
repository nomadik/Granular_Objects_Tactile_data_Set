function mymainresult = executeForPathCmd(dirname, vel)
    disp(sprintf('reading directory %s, with velocity type %d', dirname, vel)); 
    label = dirname;
    veldir = sprintf('\\grasp_palm_down_v%d\\', vel);
    fnametempl = '%s\\%s\\_slash_rh_slash_tactile.csv';
    posControllerTemplate = "%s%s_slash_sh_rh_%s_position_controller_slash_state.csv";

    names = {"ffj0", "ffj3", "mfj0", "mfj3", "rfj0", "rfj3", "lfj0", "lfj3", "thj4", "thj5"};
    counter = 1;
    posStates0 = {};
    posStates3 = {};
    disp('reading position data');
    for i=1:2:10
        %[deltatime, setPoint, procVal, procValDot, myerror, propCoeff]
        posStates3{counter} = [readPosStateCmd(sprintf(posControllerTemplate, dirname, veldir, names{i+1}))];
        counter = counter + 1;
    end
    % auto trials extraction
    mymainresult{1} = dirname;
    mymainresult{2} = posStates3; 
    
    disp('done for current path');