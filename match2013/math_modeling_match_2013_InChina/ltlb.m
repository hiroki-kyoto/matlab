clear
x=xlsread('a.xls', 'sheet1', 'D2:D42');

b=fir1(31,0.5);
d=filter(b,1,x);  
%create results:
delta = 0.001;              
ha = adaptfilt.lms(32,delta); %create a haming-window 
[y,e]=filter(ha,x,d);   
%start plotting figure
m=1:41;
figure(1);
plot(m,x,'g');
figure(2);
plot(m,e,'r');
legend('delta=0.001');
%new
figure(3);
plot(m,d,'b');
legend('ÂË²¨ºó');