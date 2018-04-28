function [train, testing, maxs, mins] = prepareForTraining(features, removeind) 
    train = [];
    testing = [];
    
    for i=1:numel(features)
        feat = features{i};
        if (isempty(feat))
            continue;
        end
        
        mytrain = feat(1:floor(0.8*end), :);
        mytest = feat(floor(0.8*end)+1:end, :);
        train = vertcat(train, mytrain);
        testing = vertcat(testing, mytest);
    end
    
    for i=1:numel(removeind)
        train(train(:, end) == removeind(i), :) = [];
        testing(testing(:, end) == removeind(i), :) = [];
    end
    a = size(train, 1);  
    % Shuffle data 
    rand_ind = randperm(size(train, 1));
    B = train(rand_ind, :); 
    tonorm = 1;
    if (tonorm == 0)
        maxs = 0;
        mins = 0;
        train = B;
        return;
    end
    % Normalize data to (0, 1) values
    maxs = max(B(:, 1:end-1));
    mins = min(B(:, 1:end-1));

    for ind=1:size(maxs,2)
        if maxs(ind) == mins(ind)
            mins(ind) = maxs(ind) - 1;
        end
    end
    C = B;
    for ind = 1:size(B, 1) 
        C(ind, :) = [(B(ind, 1:end-1) - mins) ./ (maxs - mins), B(ind, end)];
    end 
    train = C;
    
    CTEST1 = testing;
    for ind = 1:size(testing, 1)
        CTEST1(ind, :) = [(testing(ind, 1:end-1) - mins) ./ (maxs - mins), testing(ind, end)];
    end
    testing = CTEST1;
end