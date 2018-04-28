function result = featuresElectrodes(cmdData, velocityData)
    labelLen = numel(cmdData); 
    fingersFeatures = {};
    for i=1:labelLen
        label = cmdData{i}{1};
        for fingerid = 1:5
            featuresMean = {}; 
            featuresStd = {}; 
            fingerdata = velocityData{i}{2}{4}{fingerid};
            spdata = velocityData{i}{2}{5}{fingerid}{2};
            tempsp = sort(unique(spdata(numel(spdata)/2 - 250:numel(spdata)/2 + 250)));
             
            trialindex = 1;
            for trialid = 1:10
                disp(sprintf("doing label %d with finger %d and trial %d", i, fingerid, trialid));
                % extracting all data from a given class name (label)
                % second value is needed
                secval = tempsp(1);
                trstat = 0;
                startpos = 0;
                endpos = 0;
                for j=trialindex:numel(spdata)
                    if (spdata(j) == secval || trialid == 10 && spdata(j) < secval)
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
                
                featuredata = fingerdata(startpos*10:endpos*10); 
                meanvals = [];
                stdvals = [];
                for i5=1:numel(featuredata)
                    layer = featuredata{i5};
                    meanvals(i5) = nanmean(layer);
                    stdvals(i5) = nanstd(layer);
                end
                
                featuresMean = vertcat(featuresMean, [meanvals, i]);
                featuresStd = vertcat(featuresStd, [stdvals, i]);
            end
            fingersFeatures{i}{fingerid}{1} = featuresMean;
            fingersFeatures{i}{fingerid}{2} = featuresStd;
        end 
    end
    result = fingersFeatures;
end