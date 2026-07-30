function var = running_mean_2D(data_in,smooth_num)    

var        = data_in;
var_2d     = squeeze(var);
[L,M]      = size(var_2d);
N          = floor(smooth_num/2);
if mod(smooth_num,2)
V          = nan*ones(4*N+1,L,M);
V(end,:,:) = var_2d;
else
V          = nan*ones(4*N  ,L,M);
end

num = 0;
for NN=1:N
    %loop one
    num=num+1;
    V(num,1:end-N,:) = var_2d(1+N:end,:);
    %loop two
    num=num+1;
    V(num,1+N:end,:) = var_2d(1:end-N,:);
    %loop three
    num=num+1;
    V(num,:,1:end-N) = var_2d(:,1+N:end);
    %loop four
    num=num+1;
    V(num,:,1+N:end) = var_2d(:,1:end-N);
end

var = squeeze(nanmean(V));


