function [gradient, inter] = linear_fit(time, data_sequence)


xdata = time;
ydata = data_sequence;

fun = @(x, xdata) x(1)*xdata+x(2);
x0 = [0.0001,0.1];
x = lsqcurvefit(fun,x0,xdata,ydata);

gradient = x(1);
inter = x(2);

% times = xdata;
% figure; plot([xdata 3200 3400 3600 3800], [fun(x,times) NaN NaN NaN NaN]);hold on; plot([xdata 3200 3400 3600 3800],[ydata 59601 54885 57932 54918]);
% xlabel('Inversion Time');
% ylabel('Signal Intensity');
% title('Fit Linear Line (Gradient = 27.9)')
% legend('fit','original')

end