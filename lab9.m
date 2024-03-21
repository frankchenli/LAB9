clear all;
close all;
path(1).a = './data/subject1_me/20240307_Beng278_Lab9/Bolar_Beng_278/pasl_ti1_700_ri2000_8/*.dcm';
path(2).a = './data/subject1_me/20240307_Beng278_Lab9/Bolar_Beng_278/Perfusion_Weighted_5/*.dcm';
path(3).a = './data/subject1_me/20240307_Beng278_Lab9/Bolar_Beng_278/Perfusion_Weighted_9/*.dcm';
path(4).a = './data/subject1_me/20240307_Beng278_Lab9/Bolar_Beng_278/relCBF_6/*.dcm';
path(5).a = './data/subject1_me/20240307_Beng278_Lab9/Bolar_Beng_278/relCBF_10/*.dcm';
path(6).a = './data/subject1_me/20240307_Beng278_Lab9/Bolar_Beng_278/tgse_pcasl_818_p21_34x34x4_14_31_2_24slc_LT1800_16TI_800_3800_4/*.dcm';
path(7).a = './data/subject1_me/20240307_Beng278_Lab9/Bolar_Beng_278/tgse_DIR_TI1_2898_TI2_602_Best_11/*.dcm';
path(8).a = './data/subject1_me/20240307_Beng278_Lab9/Bolar_Beng_278/tgse_DIR_TI1_3426_TI2_903_Best_13/*.dcm';
label = ["PASL", "Perfusion Weighted 5", "Perfusion Weighted 9","relCBF6","relCBF10","PCASL", "DIR1", "DIR2" ];


for i = 1:8
    file = natsortfiles(dir(path(i).a));
    for j = 1: numel(file)
        data(i).image(j).each_image = dicomread(file(j).name);
        data(i).image(j).info = dicominfo(file(j).name);
        data(i).image(j).each_image = (data(i).image(j).each_image*data(i).image(j).info.RescaleSlope)+data(i).image(j).info.RescaleIntercept;
        data(i).image(j).scl_factor = data(i).image(j).info.RescaleSlope;
        data(i).image(j).scl_interc= data(i).image(j).info.RescaleIntercept;
        data(i).label = label(i);
        if i == 4 || i == 5
            a = 1;
        else
            data(i).image(j).TI = data(i).image(j).info.InversionTime;
        end
    end
end
%%

all = zeros(320,320);
for i = 2:2:64
    label = data(6).image(i).each_image;
    control = data(6).image(i+1).each_image;
    data(6).image(i).diff = double(control-label);
    all = all+data(6).image(i).diff;
end

for i = 2:2:32
    data(6).image(i).average_diff = (data(6).image(i).diff+data(6).image(i+32).diff)/2;
end

figure
imshow(data(6).image(2).average_diff,[]);
figure
imshow(data(6).image(4).average_diff,[]);
figure;
imshow(all/32,[]);


information = data(1).image(1).info;
DIR = data(8).image;
DIR2 = data(7).image;
imshow(DIR(1).each_image-DIR(2).each_image,[]);
figure;
imshow(DIR2(1).each_image-DIR2(2).each_image,[])

