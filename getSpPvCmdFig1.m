function [label, spdata, pvdata, mycmd, mypac, myfft] = getSpPvCmdFig1(vel, classind, fingerid, trialid, veld1, veld2, veld3, cmd1, cmd2, cmd3, shit)
    cmddata = 0;
    if (vel == 1)
        data = veld1;
        cmddata = cmd1;
    elseif (vel == 2)
        data = veld2;
        cmddata = cmd2;
    elseif (vel == 3)
        data = veld3;
        cmddata = cmd3;
    end

    classdata = data{classind};
    cmddata = cmddata{classind}{2}{fingerid};

    label = classdata{1};
    classdata = classdata{2};
    pac0 = classdata{1};
    electr = classdata{4};
    posstates = classdata{5};
    % fingers
    posstates = posstates{fingerid};
    pac0 = pac0{fingerid};
    electr = electr{fingerid};

    sp = posstates{2};
    pv = posstates{3};

    uvals = unique(sp(size(sp, 2)/2-500:size(sp, 2)/2+500));
    secval = min(uvals);

    trialindex = 1;
    for i=1:trialid
        trstat = 0;
        for j=trialindex:numel(sp)
            if (sp(j) == secval || trialid == 10 && sp(j) < secval)
                if (trstat == 0)
                    % first entry
                    trstat = 1;
                end
                if (trstat == 2)
                    trialindex = j;
                    endpos = j - 1;
                    break;
                end
            else
                if (trstat == 1)
                    startpos = j;
                    trstat = 2;
                end
            end
        end
    end
 
    spdata = sp(startpos - shit:endpos + shit);
    pvdata = pv(startpos - shit:endpos + shit);
    mycmd  = cmddata(startpos - shit:endpos + shit);
    
    mypac = pac0((startpos - shit)*10:(endpos + shit)*10); 
    
    close all;
    figure(1);
    hold on;
    plot(spdata, 'r');
    plot(pvdata, 'b');
    plot(max(spdata) * mycmd / max(mycmd), 'g');
    hold off;
    
    figure(2);
    hold on;
    plot(mypac, 'r');
    title("pac0");
    hold off;
    
    myfft = abs(fft(mypac));
    figure(3);
    hold on;
    plot(myfft, 'r');
    title("pac0 fft");
    hold off;
    
    electrStart = electr{startpos*10};
    electrMid = electr{(endpos + startpos)*10/2};
    electrEnd = electr{endpos*10};
    
    e1 = createElectrodeMap(electrStart);
    e2 = createElectrodeMap(electrMid);
    e3 = createElectrodeMap(electrEnd); 
    
    mymax1 = max(max(e1));
    mymax2 = max(max(e2));
    mymax3 = max(max(e3));
    
    mymax = max([mymax1, mymax2, mymax3]); 
    
    mymin1 = min(min(e1));
    mymin2 = min(min(e2));
    mymin3 = min(min(e3));
    
    mymin = min([mymin1, mymin2, mymin3]); 
    
    e1 = 255 * (e1 - mymin) / (mymax - mymin);
    e2 = 255 * (e2 - mymin) / (mymax - mymin);
    e3 = 255 * (e3 - mymin) / (mymax - mymin);
    
    e1 = uint8(e1);
    e2 = uint8(e2);
    e3 = uint8(e3);
    
    figure(4);
    im1 = image(e1);
    colormap(gray(255)); 
    
    figure(5);
    im2 = image(e2);
    colormap(gray(255)); 
    
    figure(6);
    im3 = image(e3);
    colormap(gray(255));     
end

