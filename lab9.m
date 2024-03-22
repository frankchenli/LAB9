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


%% PASL Average 24 times 
a = 1;
all = zeros(320,320);
for i = 2:2:48
    label = data(1).image(i).each_image;
    control = data(1).image(i+1).each_image;
    data(1).image(a).diff = double(control-label);
    all = all+data(1).image(a).diff;
    a = a+1;
end

PASL_ave = all/24;

imshow(PASL_ave,[5 100]);



%% Create White and Grey matter masks
grey = double(data(7).image(1).each_image);
white = double(data(8).image(1).each_image);

grey(grey<10000) = 0;
grey(grey>=10000) = 1;


white(white<13000) = 0;
white(white>=13000) = 1;

imshow(white,[]);



%% PCASL control-label
% all = zeros(320,320);

Mo_g = double(data(6).image(1).each_image).*grey;
Mo_g(Mo_g == 0) = 1;
Mo_w = double(data(6).image(1).each_image).*white;
Mo_w(Mo_w == 0) = 1;

for i = 2:2:64
    


    label_g = double(data(6).image(i).each_image).*grey;
    control_g = double(data(6).image(i+1).each_image).*grey;
    data(6).image(i).diff_gm = abs(double(control_g-label_g)./Mo_g);


    label_w = double(data(6).image(i).each_image).*white;
    control_w = double(data(6).image(i+1).each_image).*white;
    data(6).image(i).diff_wm = abs(double(control_w-label_w)./Mo_w);

    % all = all+data(6).image(i).diff;
end

%Average each pair
a = 1;
for i = 2:2:32
    data(6).image(a).average_diff_g = (data(6).image(i).diff_gm+data(6).image(i+32).diff_gm)/2;
    data(6).image(a).average_diff_w = (data(6).image(i).diff_wm+data(6).image(i+32).diff_wm)/2;
    a = a+1;
end




%% Evaluate CBF for PCASL
point = [];
figure;
for i = 1:16
    subplot(4,4,i);
    imshow(data(6).image(i).average_diff_w,[]);
    % each = data(6).image(i).average_diff(147,150);
    % point = [point, each];
end
% figure;
% plot(point);

imshow(data(6).image(3).average_diff_g,[]);


PLD = [0 0 0 0 0 0 200 400 600 800 1000 1200 1400 1600 1800 2000];
tau = [800 1000 1200 1400 1600 1800 1800 1800 1800 1800 1800 1800 1800 1800 1800 1800];
TI = PLD+tau;






% stem()



% information = data(1).image(1).info;
% DIR = data(8).image;
% DIR2 = data(7).image;
% imshow(DIR(1).each_image-DIR(2).each_image,[]);
% figure;
% imshow(DIR2(1).each_image-DIR2(2).each_image,[])

