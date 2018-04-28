function [deltatime, pac0_1, pac0_2, pac0_3, pac0_4, pac0_5, ...
    pac1_1, pac1_2, pac1_3, pac1_4, pac1_5, ...
    pdc_1, pdc_2, pdc_3, pdc_4, pdc_5, ...
    electrode1, electrode2, electrode3, electrode4, electrode5] = readTactile(fname)

    fid = fopen(fname); 
    header = fgets(fid);

    deltatime = [];
    pac0_1 = [];
    pac0_2 = [];
    pac0_3 = [];
    pac0_4 = [];
    pac0_5 = [];

    pac1_1 = [];
    pac1_2 = [];
    pac1_3 = [];
    pac1_4 = [];
    pac1_5 = [];

    pdc_1 = [];
    pdc_2 = [];
    pdc_3 = [];
    pdc_4 = [];
    pdc_5 = [];
    
    electrode1 = {};
    electrode2 = {};
    electrode3 = {};
    electrode4 = {};
    electrode5 = {};

    while(~feof(fid))
        line = fgets(fid);
        % nsecs 6. pac0pac1pdc-9-10-11, 

        mysplit = split(line, ',');
        nsecval = mysplit(6);
        %mysplit(110:128) = {'shit'};
        %mysplit(86:104) = {'shit'};
        %mysplit(62:80) = {'shit'};
        %mysplit(38:56) = {'shit'};
        %mysplit(14:32) = {'shit'};
        
        % first part 14:32
        elec1 = getElectrodeValuesFromSplit(mysplit(14:32));
        elec2 = getElectrodeValuesFromSplit(mysplit(38:56));
        elec3 = getElectrodeValuesFromSplit(mysplit(62:80));
        elec4 = getElectrodeValuesFromSplit(mysplit(86:104));
        elec5 = getElectrodeValuesFromSplit(mysplit(110:128));
        
        electrode1{numel(electrode1) + 1} = elec1;
        electrode2{numel(electrode2) + 1} = elec2;
        electrode3{numel(electrode3) + 1} = elec3;
        electrode4{numel(electrode4) + 1} = elec4;
        electrode5{numel(electrode5) + 1} = elec5;
        
        deltatime=[deltatime (str2double(cell2mat(nsecval)))];
        ind = 9;
        pac0_1=[pac0_1 (str2double(cell2mat(mysplit(ind))))];
        pac1_1=[pac1_1 (str2double(cell2mat(mysplit(ind+1))))];
        pdc_1=[pdc_1 (str2double(cell2mat(mysplit(ind+2))))];

        ind = 33;
        pac0_2=[pac0_2 (str2double(cell2mat(mysplit(ind))))];
        pac1_2=[pac1_2 (str2double(cell2mat(mysplit(ind+1))))];
        pdc_2=[pdc_2 (str2double(cell2mat(mysplit(ind+2))))];

        ind = 57;
        pac0_3=[pac0_3 (str2double(cell2mat(mysplit(ind))))];
        pac1_3=[pac1_3 (str2double(cell2mat(mysplit(ind+1))))];
        pdc_3=[pdc_3 (str2double(cell2mat(mysplit(ind+2))))];

        ind = 81;
        pac0_4=[pac0_4 (str2double(cell2mat(mysplit(ind))))];
        pac1_4=[pac1_4 (str2double(cell2mat(mysplit(ind+1))))];
        pdc_4=[pdc_4 (str2double(cell2mat(mysplit(ind+2))))];

        ind = 105;
        pac0_5=[pac0_5 (str2double(cell2mat(mysplit(ind))))];
        pac1_5=[pac1_5 (str2double(cell2mat(mysplit(ind+1))))];
        pdc_5=[pdc_5 (str2double(cell2mat(mysplit(ind+2))))];
    end
    fclose(fid);