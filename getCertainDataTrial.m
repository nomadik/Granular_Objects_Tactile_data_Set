function result = getCertainDataTrial(label, velocity, finger, trial, velocitydata_alltogether)
    velocityData = velocitydata_alltogether{velocity};
    
    for i=1:numel(velocityData)
        veldata = velocityData{i};
        if (isempty(veldata))
            continue;
        end
        if (strcmp(veldata{4}, label) == 1)
            break;
        end
    end
    
    pac0trials = veldata{1};
    pac0trials = pac0trials{finger};
    pac1trials = veldata{2};
    pac1trials = pac1trials{finger};
    electrials = veldata{3};
    electrials = electrials{finger};
    origpdctrials = veldata{6};
    origpdctrials = origpdctrials{finger};
    origspdottrials = veldata{7};
    origspdottrials = origspdottrials{finger};
    alldata = veldata{8};
    rangestrials = veldata{9};
    myrange = rangestrials{finger};
    pac0fulltrials = veldata{10};
    pac0fulltrials = pac0fulltrials{finger};
    
    pac0full = pac0fulltrials{trial};
    pac0 = pac0trials{trial};
    pac1 = pac0trials{trial};    
    elec = electrials{trial};
    pdc = origpdctrials{trial};
    spdot = origspdottrials{trial};
    myrange = myrange{trial};
    
    result{1} = pac0;
    result{2} = pac1;
    result{3} = elec;
    result{4} = pdc;
    result{5} = spdot;
    result{6} = myrange;
    result{7} = alldata;
    result{8} = pac0full;