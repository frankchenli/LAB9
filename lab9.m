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


%% Single PASL Average 24 times 
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

% imshow(PASL_ave,[5 100]);



%% Create White and Grey matter masks
grey = double(data(7).image(1).each_image);
white = double(data(8).image(1).each_image);

grey(grey<10000) = 0;
grey(grey>=10000) = 1;


white(white<12000) = 0;
white(white>=12000) = 1;


% figure;
% subplot(2,2,1);
% imshow(double(data(7).image(1).each_image),[]);
% title('DIR Grey Matter')
% subplot(2,2,2);
% imshow(double(data(8).image(1).each_image),[]);
% title('DIR White Matter')
% 
% subplot(2,2,3);
% imshow(grey,[]);
% title('Grey Matter Mask(Threshold = 10000)')
% subplot(2,2,4);
% imshow(white,[]);
% title('White Matter Mask(Threshold = 12000)')


%% PCASL control-label, M0 normalization and T1 correction

PLD = [0 0 0 0 0 0 200 400 600 800 1000 1200 1400 1600 1800 2000];
tau = [800 1000 1200 1400 1600 1800 1800 1800 1800 1800 1800 1800 1800 1800 1800 1800];
TI = PLD+tau;
T1_blood = 1650;
T1_cor = exp(PLD/T1_blood)./(1-exp(-(tau/T1_blood)));

% figure;
% exmp = [1 2 3 4 5 6 6 6 6 6 6 6 6 6 6 6];
% decay = exmp./T1_cor;
% plot(decay);
% hold on
% plot(decay.*T1_cor);



Mo_g = 10*double(data(6).image(1).each_image).*grey;
Mo_g(Mo_g == 0) = 1;
Mo_w = 10*double(data(6).image(1).each_image).*white;
Mo_w(Mo_w == 0) = 1;

for i = 2:2:64


    label_g = double(data(6).image(i).each_image).*grey;
    control_g = double(data(6).image(i+1).each_image).*grey;
    data(6).image(i).diff_gm = abs(double(control_g-label_g)./Mo_g);


    label_w = double(data(6).image(i).each_image).*white;
    control_w = double(data(6).image(i+1).each_image).*white;
    data(6).image(i).diff_wm = abs(double(control_w-label_w)./Mo_w);

end


%Average each pair and T1 correction
a = 1;
for i = 2:2:32
    data(6).image(a).average_diff_g = T1_cor(a)*(data(6).image(i).diff_gm+data(6).image(i+32).diff_gm)/2;
    data(6).image(a).average_diff_w = (data(6).image(i).diff_wm+data(6).image(i+32).diff_wm)/2;
    a = a+1;
end



% figure;
% for i = 1:16
%     subplot(4,4,i);
%     imshow(data(6).image(i).average_diff_w,[0.0001 0.05]);
% end
% sgtitle('White Matter Perfusion Images(Control - Label)')


%% Formula Evaluate CBF for PCASL

for i = 1:16
    CBF_g(:,:,i) = (6000*0.9*data(6).image(i).average_diff_g*T1_cor(i))/(2*0.85*1.65);
    CBF_w(:,:,i) = (6000*0.9*data(6).image(i).average_diff_w*T1_cor(i))/(2*0.85*1.65);
end

CBF_g = mean(CBF_g,3);
CBF_w = mean(CBF_w,3);

subplot(1,2,1);
imshow(CBF_g,[5 100]);
title('Grey Matter CBF(Window[5, 100])')
subplot(1,2,2);
imshow(CBF_w,[5 20]);
title('White Matter CBF(Window[5, 20])')

figure;
imshow(CBF_g+CBF_w,[5 100]);
title('Brain CBF')

%% Line Fit to evaluate CBF

constant = 6000*0.9*1000;


% all  = [];
% for i = 1:16
%     each = data(6).image(i).average_diff_g(170,145);
%     all = [all each];
% end
% all = all*constant/10;
% plot(TI, all);
% xlabel('Inversion Time');
% ylabel('Signal Intensity');
% title('Pixel(170,145)')
% [a,b] = linear_fit(TI(1:12),all(1:12));




CBF_g_line = zeros(320,320);
CBF_w_line = zeros(320,320);
pointw_matrix = [];
pointg_matrix = [];
slope_w = [];
slope_g = [];
for i = 1:size(white,1)
    for j = 1:size(white,2)
        points1 = [];
        points2 = [];
        if grey(i,j) == 1
            for k = 1:16
                point = data(6).image(k).average_diff_g(i,j);
                points1 = [points1 point];
            end
            [mini index] = min(points1);
            [maxi I] = max(points1);
            pointg_matrix = [pointg_matrix; points1];
            [gradient, inter] = linear_fit(double(TI(index:I)),double(points1(index:I)));
            CBF_g_line(i,j) = gradient;
        end
        a = 1;
        if white(i,j) == 1
            for k = 1:16
                point2 = data(6).image(k).average_diff_w(i,j);
                points2 = [points2 point2];
            end
            [mini2 index2] = min(points2);
            [maxi2 I2] = max(points2);
            [gradient2, inter2] = linear_fit(double(TI(index2:I2)),double(points2(index2:I2)));
            CBF_w_line(i,j) = gradient2;
            pointw_matrix = [pointw_matrix; points2];
        end

    end
end


CBF_g_line = CBF_g_line*constant;
CBF_w_line = CBF_w_line*constant;


figure;
subplot(1,2,1)
imshow(CBF_w_line+CBF_g_line,[5 100]);
title('Linear Fit Gradient Whole Brain CBF','FontSize', 20)

subplot(1,2,2)
imshow(CBF_w+CBF_g,[5 100]);
title('Equation Evaluated Whole Brain CBF','FontSize', 20)
sgtitle('Window Level = [5, 100]')


figure;
imshow(abs(CBF_w+CBF_g-CBF_w_line-CBF_g_line),[5 100]);
title('Whole Brain CBF Difference (Equation Result - Line fit Result)','FontSize', 20)
sgtitle('Window Level = [5, 100]')


