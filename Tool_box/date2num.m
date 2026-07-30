function [year,month,day,hour,minu,seco] = date2num(T);

TIME  = datevec(T);
year  = TIME(1);
month = TIME(2);
day   = TIME(3);
hour  = TIME(4);
minu  = TIME(5);
seco  = TIME(6);

