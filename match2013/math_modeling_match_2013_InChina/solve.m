clear;
clc;
d=1;
d.time=xlsread('a.xls','sheet1','A2:A42');
d.x=xlsread('a.xls','sheet1','B2:B42');
d.y=xlsread('a.xls','sheet1','C2:C42');
d.z=xlsread('a.xls','sheet1','D2:D42');
d.alpha=xlsread('a.xls','sheet1','E2:E42');
d.theta=xlsread('a.xls','sheet1','F2:F42');
d.vx=xlsread('a.xls','sheet1','G2:G42');
d.vy=xlsread('a.xls','sheet1','H2:H42');
d.vz=xlsread('a.xls','sheet1','I2:I42');
%use a circle to produce a array of position:
%lx:
d.like=0;
d.like(1)=d.x(1);
for i=2:41
    d.like(i)=d.like(i-1)+d.vx(i-1)*0.15;
end
lx=d.like;
%ly:
d.like=0;
d.like(1)=d.y(1);
for i=2:41
    d.like(i)=d.like(i-1)+d.vy(i-1)*0.15;
end
ly=d.like;
%lz:
d.like=0;
d.like(1)=d.z(1);
for i=2:41
    d.like(i)=d.like(i-1)+d.vz(i-1)*0.15;
end
lz=d.like;
p=polyfit([d.time]',lz,1);
display(p);
%plot3(lx,ly,lz);
%xlabel('lx');
%ylabel('ly');
%zlabel('lz');





