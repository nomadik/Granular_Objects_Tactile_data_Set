mydata{1} = velocityData1;
mydata{2} = velocityData2;
mydata{3} = velocityData3;
%% for testing
dotest = 0;
if (dotest == 1)
    for i=1:numel(labels)
        data1 = getCertainDataTrial(labels(i), 1, 1, 1, mydata);
        data2 = getCertainDataTrial(labels(i), 1, 3, 1, mydata);
        alldata1 = data1{7};
        alldata2 = data2{7};
        alldata1 = alldata1{5};
        alldata2 = alldata2{5};

        alldata1 = alldata1{1};
        alldata2 = alldata2{3};

        sp1 = alldata1{2};
        sp3 = alldata2{2};
        close all; hold on; plot(sp1); plot(sp3); hold off;
        drawnow;
        pause();
    end
end
%% get label names
labels = {};
len = 0;
for i=1:numel(velocityData1)
    val = velocityData1{i};
    if (isempty(val))
        continue;
    end
    name = val{4};
    len = len + 1;
    labels{len} = name;
end

%%
iwantvelocity = 1;
features = {};
for i=1:numel(mydata{iwantvelocity})
    features{i} = [];
end

maxlen = 0;
feati = 0;

sizetest = [];

for i=1:numel(labels)
    label = labels{i};
    for iwantfinger = 1:5
        if (iwantfinger == 3)
            continue;
        end
        for iwanttrial = 1:10
            disp(sprintf("doing label %d with trial %d", i, iwanttrial));
            mytrialdata = getCertainDataTrial(label, iwantvelocity, ...
                iwantfinger, iwanttrial, mydata);
            if (isempty(mytrialdata))
                continue;
            end

            pacfull0 = mytrialdata{8};
            pac0 = mytrialdata{1}; % extracted trial pac0
            pac1 = mytrialdata{2}; % extracted trial pac1
            elec = mytrialdata{3}; % extracted trial electrodes
            pdc = mytrialdata{4};  % pdc full trial data
            spdot = mytrialdata{5};% set point dot full trial data
            myrange = mytrialdata{6};
            alldata = mytrialdata{7};

            % extracting all data from a given class name (label)
            fingersPac0 = alldata{1};
            fingersPac1 = alldata{2};
            fingersPdc = alldata{3};
            fingersElec = alldata{4};
            fingersPositionStatesJ3 = alldata{5};

            if (numel(pac0) > maxlen)
                maxlen = numel(pac0);
                %disp(maxlen);
            end

            [mmax, mmaxind] = max(spdot);
            
            if (mmax < 1)
                continue;
            end
            
            N = 250;
            Fc1 = 128;
            Fc2 = 129;

            %
            howmuchtotake = 200;
            %filtpac0 = filter(highpassfilter(N, Fc1, Fc2), pac0);
            sstart = mmaxind*10-howmuchtotake;
            if (sstart < 1)
                sstart = 1;
                %disp(sprintf("shit at label %s, finger %d trial %d", label, iwantfinger, iwanttrial));
            end
            filtpac0 = getDesiredRegionFromPac(pacfull0);
            sizetest = vertcat(sizetest, numel(filtpac0));
            doplot = 0;
            if (doplot == 1)
                plotTrial(pac0, filtpac0, pdc, spdot, myrange);
                pause();
            end

            myN = 250;
            for myI = 1:10:numel(filtpac0)-myN
                feati = feati + 1;
                myvector = filtpac0(myI:myI+myN-1);
                myvector = abs(fft(myvector, numel(myvector)));
                %myfeature = myfeature(2:end/2); 
                features{i} = vertcat(features{i}, [myvector, i]);
            end
        end
    end
    % below is an example of reading original data of position states 
    %for myfingind=1:numel(fingersPositionStatesJ3)
    %    myfingerdata = fingersPositionStatesJ3{myfingind};
    %    deltaTJ3_F1 = myfingerdata{1};
    %    setPointJ3_F1 = myfingerdata{2};
    %    procValJ3_F1 = myfingerdata{3};
    %    procValDotJ3_F1 = myfingerdata{4};
    %    errValsJ3_F1 = myfingerdata{5};
    %    velJ3_F1 = myfingerdata{6}; 
    %end
end

removeind = [1:4, 6,9,11:12,13,14,15, 17];
% 1 2 3 7 10 12 
%removeind=[4:6, 8, 9, 11, 13:16];
[traindata, testingdata, maxs, mins] = prepareForTraining(features, removeind);

%5-11 13 16 17 
disp("finished");