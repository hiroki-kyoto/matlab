clear;
clc;
% intial parameters
n_iter = 41; %计算连续n_iter个时刻
sz = [n_iter, 1]; % size of array. n_iter行，1列
%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q = 1e-4; % wait for seeking
R = 0.05; % wait 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
z = xlsread('a.xls','sheet1','C2:C42'); % z是温度计的测量结果，在真实值的基础上加上了方差为0.25的高斯噪声。
% 对数组进行初始化
xhat=zeros(sz); % 对温度的后验估计。即在k时刻，结合温度计当前测量值与k-1时刻先验估计，得到的最终估计值
P=zeros(sz); % 后验估计的方差
xhatminus=zeros(sz); % 温度的先验估计。即在k-1时刻，对k时刻温度做出的估计
Pminus=zeros(sz); % 先验估计的方差
K=zeros(sz); % 卡尔曼增益，反应了温度计测量结果与过程模型（即当前时刻与下一时刻温度相同这一模型）的可信程度
% intial guesses
xhat(1) = z(1); %温度初始估计值为23.5度
P(1) =1; %误差方差为1
for k = 2:n_iter
% 时间更新（预测）
xhatminus(k) = xhat(k-1); %用上一时刻的最优估计值来作为对当前时刻的温度的预测
Pminus(k) = P(k-1)+Q; %预测的方差为上一时刻温度最优估计值的方差与过程方差之和
% 测量更新（校正）
K(k) = Pminus(k)/( Pminus(k)+R ); %计算卡尔曼增益
xhat(k) = xhatminus(k)+K(k)*(z(k)-xhatminus(k)); %结合当前时刻温度计的测量值，对上一时刻的预测进行校正，得到校正后的最优估计。该估计具有最小均方差
P(k) = (1-K(k))*Pminus(k); %计算最终估计值的方差
end
FontSize=12;
LineWidth=2;
figure();
plot(z,'k+'); %画出温度计的测量值
hold on;
plot(xhat,'b-','LineWidth',LineWidth) %画出最优估计值
legend('Q=1e-4;R=0.05后验估计');
xl=xlabel('时间(x0.15s)');
yl=ylabel('距离y(m)');
set(xl,'fontsize',FontSize);
set(yl,'fontsize',FontSize);
hold off;
set(gca,'FontSize',FontSize);
figure();
valid_iter = [2:n_iter]; % Pminus not valid at step 1
plot(valid_iter,P([valid_iter]),'LineWidth',LineWidth); %画出最优估计值的方差
legend('Q=1e-4;R=0.05后验估计方差');
xl=xlabel('时间(x0.15s)');
yl=ylabel('m^2');
set(xl,'fontsize',FontSize);
set(yl,'fontsize',FontSize);
set(gca,'FontSize',FontSize);
xlswrite('d3.xls', xhat);
