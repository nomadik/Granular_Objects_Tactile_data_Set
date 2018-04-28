function result = reducedata(data)
    shit = data;
    shit(17) = [];
    shit(16) = [];
    shit(14) = [];
    len = numel(shit);
    for i=1:len
        shit{i}(10) = [];
        shit{i}(9) = [];
        shit{i}(1) = [];
        shit{i}(1) = [];
        shit{i}(1) = [];
        shit{i}(2) = [];
        shit{i}(2) = [];
        shit{i}(2) = [];
    end
    result = shit;
end