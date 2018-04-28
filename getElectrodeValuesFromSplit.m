function result = getElectrodeValuesFromSplit(mysplit)
    result = [];
    for i=1:numel(mysplit)
        val = cell2mat(mysplit(i));
        if (i == 1)
            val = val(3:end);
        elseif (i == numel(mysplit))
            tval = val;
            ind = strfind(tval, ']');
            val = val(1:ind-1);
        end
        val = str2double(val);
        result = [result val];      
    end
    