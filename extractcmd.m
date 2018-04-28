%% tactile data is 10 times more than position data
clear all; close all; clc;
%% scan cur dir
dirs = dir('.');
flag = 0;
cmdData1 = {};
cmdData2 = {};
cmdData3 = {};
counter = 0;
%%
for d=1:numel(dirs)
    if (dirs(d).isdir == 1 && strcmp(dirs(d).name, '.') ~= 1 && strcmp(dirs(d).name, '..') ~= 1)
        if (flag == 0)
            flag = 1;
            continue;
        end
        if (strcmp(dirs(d).name, 'images') == 1 || strcmp(dirs(d).name, 'no_object') == 1)
            continue;
        end
        tic;
        disp(sprintf('reading for directory %s', dirs(d).name));
        counter = counter + 1;
        veldir = sprintf('\\grasp_palm_down_v%d\\', 1);
        if (exist(sprintf('%s\\%s', dirs(d).name, veldir),'dir') == 7)
        
            disp('reading velocity 1 data');
            cmdData1{counter} = executeForPathCmd(dirs(d).name, 1);
        
        end
        veldir = sprintf('\\grasp_palm_down_v%d\\', 2);
        if (exist(sprintf('%s\\%s', dirs(d).name, veldir),'dir') == 7)
            disp('reading velocity 2 data');
            cmdData2{counter} = executeForPathCmd(dirs(d).name, 2);
        end
        veldir = sprintf('\\grasp_palm_down_v%d\\', 3);
        if (exist(sprintf('%s\\%s', dirs(d).name, veldir),'dir') == 7)
            disp('reading velocity 3 data');
            cmdData3{counter} = executeForPathCmd(dirs(d).name, 3);
        end
        mytime = toc;
        disp("mytime in seconds");
        disp(mytime);
    end
end
save('mydata.mat');
disp('finished');
 