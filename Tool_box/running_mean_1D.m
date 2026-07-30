function [data_out] = running_mean_1D(data_in,point_num)
data_out =NaN * data_in;
    for i = 1+floor(point_num/2):length(data_in)-floor(point_num/2)
        data_out(i) = nanmean(data_in(i-floor(point_num/2):i+floor(point_num/2)));
%         data_out(i-floor(point_num/2)) = nanmean(data_in(i-floor(point_num/2):i+floor(point_num/2)));
    end
