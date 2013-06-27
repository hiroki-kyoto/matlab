%用高度拟合曲线和高度滤波后曲线求算最小方差下的累计常量误差：
%已知：Z(t) = 0.6626*t + 510.3998; H*=H-i*segoma;
%要求的是∑[Z(0.15k)-H*(k)]^2 --最终表达式含有segoma的一个一元二次方程
%求解让这个表达式值最小的segoma的值。
clear;
clc;
m=-0.0994;
k=[1:1:41]';
H=xlsread('b1.xls','sheet1','A1:A41');
n=510.3043-H(k);
changshu=sum((m*k+n).*(m*k+n));
yijie=sum(2*(m*k+n));
erjie=sum(k.*k);
display([changshu,yijie,erjie]);