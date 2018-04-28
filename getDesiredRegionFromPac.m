function result = getDesiredRegionFromPac(data) 
    result = [];
    data = data - 2000;
    startind = 1;
    endind = numel(data);
    for i=1:numel(data)
        if (abs(data(i))>100)
            startind = i;
            break;
        end
    end
    for i=1:numel(data)
        if (abs(data(numel(data)-i+1))>100)
            endind = numel(data) - i + 1;
            break;
        end
    end
    result = data(startind:endind);