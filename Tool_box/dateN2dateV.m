function T_num = dateN2dateV(num)
T     = datevec(num);
year  = T(1);
month = T(2);
day   = T(3);
if month<10
    month_num = ['0',num2str(month)];
else
    month_num = num2str(month);
end
if day<10
    day_num = ['0',num2str(day)];
else
    day_num = num2str(day); 
end
T_num = [num2str(year),month_num,day_num];