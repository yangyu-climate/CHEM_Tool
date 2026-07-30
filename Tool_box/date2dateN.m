function D=date2dateN(T)

TIME  = datevec(T);
year  = TIME(1);
month = TIME(2);
day   = TIME(3);

num   = datenum([year month day]) -  datenum([year 1 0]);

if num<10
    D = [num2str(year),'00',num2str(num)];
elseif num<100
    D = [num2str(year),'0',num2str(num)];
else
    D = [num2str(year),num2str(num)];
end