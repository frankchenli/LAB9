function [gradient, inter] = linear_fit(time, data_sequence)


xdata = time;
ydata = data_sequence;

fun = @(x, xdata) x(1)*xdata+x(2);
x0 = [0.0001,0.1];
x = lsqcurvefit(fun,x0,xdata,ydata);

gradient = x(1);
inter = x(2);

% times = linspace(xdata(1),xdata(end));
% figure; plot(times, fun(x,times));hold on; plot(xdata,ydata);
% legend('fit','original')
    
end