clear all;
close all;
path1 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/pasl_ti1_700_ri2000_8/*.dcm';
path2 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/Perfusion_Weighted_5/*.dcm';
path3 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/Perfusion_Weighted_9/*.dcm';
path4 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/relCBF_6/*.dcm';
path5 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/relCBF_10/*.dcm';
path6 = './data/subject1/20240307_Beng278_Lab9/Bolar_Beng_278/tgse_pcasl_818_p21_34x34x4_14_31_2_24slc_LT1800_16TI_800_3800_4/*.dcm';



filename1 = dir(path6);


for i = 1:numel(filename1)
    data(i).cbf6 = dicomread(filename1(i).name);
    data(i).info = dicominfo(filename1(i).name);
    data(i).series = data(i).info.SeriesNumber;
end


% for i = 1:numel(filename1)
%     figure;
%     imshow(data(i).cbf6,[]);
% end

imshow(data(30).cbf6,[500 20000]);
