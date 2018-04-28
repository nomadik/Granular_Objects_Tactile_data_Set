function result = createElectrodeMap(electr)
%V1 = avg(E17, E18, E12, E2, E13, E3) and V2 = avg(E17, E18, E15, E5, E13, E3).
    result = zeros(7, 3);
    result(1, 1) = electr(8);
    result(1, 2) = electr(7);
    result(1, 3) = electr(9);
        
    result(2, 2) = electr(10);
    result(3, 2) = electr(17);
    
    result(6, 2) = electr(18);
    result(7, 2) = electr(19);
    
    for i=1:6
        result(i + 1, 1) = electr(i);
        result(i + 1, 3) = electr(10 + i);
    end
    
    v1 = [electr(17), electr(18), electr(12), electr(2), electr(13), electr(3)];
    v2 = [electr(17), electr(18), electr(15), electr(5), electr(13), electr(3)];
    result(4, 2) = mean(v1);
    result(5, 2) = mean(v2);
end