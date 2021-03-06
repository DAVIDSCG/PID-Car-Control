clear all; clc; close all;
% 初始化参数
n_iter = 100;        % 计算连续n_iter个时刻
sz = [n_iter, 1];     % 序列的大小
x = 24;                % 温度的真实值（恒定不变的保持24°C）
Q = 4e-4;            % 对温度预测值的方差
R = 0.25;             % 测量方差，反应温度计的测量精度
T_start = 23.5;        % 温度初始估计值
delta_start = 2;    % 温度初始估计方差
% z是温度计的测量结果，在真实值的基础上加上了方差为0.25的高斯噪声。
z = x + sqrt(R)*randn(sz); 

% 初始化数组
state_kalman = zeros(sz); 
% 对温度的估计值。即在k时刻，结合温度计当前测量值与k-1时刻预测值，得到的最终估计值
variance_kalman = zeros(sz);            % 估计值的方差
state_pre = zeros(sz);                       % 对温度的预测
variance_pre = zeros(sz);                  % 预测值的方差
K = zeros(sz);                                   % 卡尔曼增益
state_kalman(1) = T_start;               %温度估计值初始化
variance_kalman(1) = delta_start;    %估计值方差初始化

%开始迭代计算（五行分别对应五个公式）
for k = 2 : n_iter
    % 用上一时刻的最优状态估计值来作为对当前时刻的温度的预测
    state_pre(k) = state_kalman(k-1);
    % 预测的方差为上一时刻温度最优估计值的方差与高斯噪声方差之和
    variance_pre(k) = variance_kalman(k-1) + Q;
    % 计算卡尔曼增益
    K(k) = variance_pre(k)/( variance_pre(k) + R ); 
    % 结合当前时刻温度计的测量值，对上一时刻的预测进行校正，得到校正后的最优估计。由于是直接测量，故C为1.
    state_kalman(k) = state_pre(k) + K(k) * (z(k) - state_pre(k)); 
    % 计算最终估计值的方差用于下一次迭代
    variance_kalman(k) = (1 - K(k)) * variance_pre(k);
end

%-----------------------------------------------------------------------------------------------------
%绘图相关
LineWidth=2;
figure;
plot(z,'k+'); %画出温度计的测量值
hold on;
plot(state_kalman,'b-','LineWidth',LineWidth) %画出最优估计值
hold on;
plot(x*ones(sz),'g-','LineWidth',LineWidth); %画出真实值
legend('温度测量值', 'Kalman估计值', '真实值');
hold off;

% 画出均方误差的变化情况
figure;
valid_iter = [2 : n_iter]; % variance_pre not valid at step 1
plot(valid_iter,variance_kalman([valid_iter]),'LineWidth',LineWidth); %画出最优估计值的方差
legend('Kalman估计的误差估计');








