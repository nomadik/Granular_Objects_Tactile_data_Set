function [myresultpacfull0, myresultpac0, myresultpac1, myresultelec, myorigpdc, myorigspdot, myextractedranges] = getTrialsData(setPointJ3_F1, procValDotJ3_F1, pdc_orig, pac0_1, pac1_1, elec, ...
    mylabel, myvelocity, mybigdi_fingerid)

    filtN = 500;
    cuttoffFilt = 10;
    pdc_1 = filter(myfilter(filtN, cuttoffFilt), pdc_orig);
     
    myminspval = min(setPointJ3_F1);
    pdc_zero_ind = (find(setPointJ3_F1~=myminspval, 1, 'first') - 1)*10 - 1;
    meanpdc1 = mean(pdc_1(pdc_zero_ind/2:pdc_zero_ind));
    maxsetpointval = max(setPointJ3_F1);
    flag = 0;
    setPointRanges = {};
    sprcounter = 0;
    for myind=1:numel(setPointJ3_F1)
        if (setPointJ3_F1(myind) == maxsetpointval)
            if (flag == 0)
                flag = 1;
                startind = myind;
                continue;
            else 
                continue;
            end;
        elseif (flag == 1)
            flag = 0;
            endind = myind - 1;
            sprcounter = sprcounter + 1;
            setPointRanges{sprcounter} = [startind:endind];
        end
    end
    
    winsize = 5;
    eps = 0.02;
    myresultpac0 = {};
    myresultpac1 = {};
    % for every trial (usually 10)
    for myind=1:numel(setPointRanges)
        myrange = setPointRanges{myind}; % next set point range
        myspdot = procValDotJ3_F1(:, myrange);
        %mystd = movstd(myspdot, winsize); % thats wrong approach. just
        %horrible
        mystd = myspdot; % search near zero of original data
        [mymax, mymaxind] = max(mystd);
        tempcount = 0;
        for kkk=mymaxind:numel(mystd)
            if (abs(mystd(kkk)) < eps)
                tempcount = tempcount + 1;
            else
                tempcount = 0;
            end
            if (tempcount == winsize)
                break;
            end
        end
        myendpoint = kkk - floor(winsize / 2);
        
        halfwin = floor(filtN/2);
        mytemp = pdc_1(:,[myrange(1)*10+halfwin:myrange(end)*10+halfwin]) - meanpdc1;
        %mystd = movstd(mytemp, winsize*10); % let's try the other way
        mystd = (mytemp - min(mytemp))/(max(mytemp) - min(mytemp));
        [mymax, mymaxind] = max(mytemp);
        tempcount = 0;
        eps2 = 0.2;
        for kkk=1:mymaxind
            if (abs(mystd(kkk)) > eps2)
                tempcount = tempcount + 1;
            else
                tempcount = 0;
            end
            if (tempcount == winsize)
                break;
            end
        end
        mystartpoint = kkk;
        if (mystartpoint < 1)
            mystartpoint = 1;
        end
        myendpoint = myendpoint * 10 - 1; % convert to higher frequency range
    
        pac0Data = pac0_1(:,[myrange(1)*10:myrange(end)*10]);
        pac1Data = pac1_1(:,[myrange(1)*10:myrange(end)*10]);
        pac0full = pac0Data;
        pac0Data = pac0Data(mystartpoint:myendpoint);
        pac1Data = pac1Data(mystartpoint:myendpoint);
        elecdata = elec(mystartpoint:myendpoint);
        myresultpacfull0{myind} = pac0full;
        myresultpac0{myind} = pac0Data;
        myresultpac1{myind} = pac1Data;
        myresultelec{myind} = elecdata;
        myorigpdc{myind} = mytemp;
        myorigspdot{myind} = myspdot;
        myextractedranges{myind} = {mystartpoint, myendpoint};
         
        plotandsave = 1;
        
        if (plotandsave == 1)
            figure(1);
            clf;
            subplot(2,3,1);
            plot(myspdot);
            title('set point velocity');
            subplot(2,3,2);
            plot(mytemp);
            title('pdc');
            subplot(2,3,5);
            plot(mytemp(mystartpoint:myendpoint));
            title('pdc crop');
            subplot(2,3,4);
            plot(myspdot(floor(mystartpoint/10) + 1:floor(myendpoint/10)));
            title('set point velocity crop');

            subplot(2,3,3);
            plot(pac0_1(:,[myrange(1)*10:myrange(1)*10+numel(pac0Data)*2]));
            title('pac0 (cut little bit)');
            subplot(2,3,6);
            plot(pac0Data);
            title('pac0 crop');
            drawnow; 
            saveas(gcf, sprintf('images/%s_vel%d_fingerid%d_trial%d.png', mylabel, myvelocity, mybigdi_fingerid, myind)); 
            disp('ko');
        end
    end
    