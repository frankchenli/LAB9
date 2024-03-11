clear all;
close all;
path1 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/pasl_ti1_700_ri2000_8/*.dcm';
path2 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/Perfusion_Weighted_5/*.dcm';
path3 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/Perfusion_Weighted_9/*.dcm';
path4 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/relCBF_6/*.dcm';
path5 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/relCBF_10/*.dcm';
path6 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/tgse_pcasl_818_p21_34x34x4_14_31_2_24slc_LT1800_16TI_800_3800_4/*.dcm';



filename1 = natsortfiles(dir(path1));
filename2 = natsortfiles(dir(path2));
filename3 = natsortfiles(dir(path3));
filename4 = natsortfiles(dir(path4));
filename5 = natsortfiles(dir(path5));
filename6 = natsortfiles(dir(path6));


for i = 1:numel(filename1)
    data(i).pasl = dicomread(filename1(i).name);
    data(i).info = dicominfo(filename1(i).name);
    data(i).series = data(i).info.SeriesNumber;
end

for i = 1:numel(filename2)
    data(i).pw5 = dicomread(filename2(i).name);
    % data(i).info = dicominfo(filename1(i).name);
    % data(i).series = data(i).info.SeriesNumber;
end

data(1).pw10 = dicomread(filename3(1).name);

for i = 1:numel(filename4)
    data(i).cbf6 = dicomread(filename4(i).name);
    % data(i).info = dicominfo(filename1(i).name);
    % data(i).series = data(i).info.SeriesNumber;
end

data(1).cbf10 = dicomread(filename5(1).name);

for i = 1:numel(filename6)
    data(i).pcasl = dicomread(filename6(i).name);
    % data(i).info = dicominfo(filename1(i).name);
    % data(i).series = data(i).info.SeriesNumber;
end


figure;
imshow(data(4).pasl,[500 20000]);
figure;
imshow(data(5).pasl,[500 20000])
