clear all; clc; close all;
% ��ʼ������
n_iter = 100;        % ��������n_iter��ʱ��
sz = [n_iter, 1];     % ���еĴ�С
x = 24;                % �¶ȵ���ʵֵ���㶨����ı���24��C��
Q = 4e-4;            % ���¶�Ԥ��ֵ�ķ���
R = 0.25;             % ���������Ӧ�¶ȼƵĲ�������
T_start = 23.5;        % �¶ȳ�ʼ����ֵ
delta_start = 2;    % �¶ȳ�ʼ���Ʒ���
% z���¶ȼƵĲ������������ʵֵ�Ļ����ϼ����˷���Ϊ0.25�ĸ�˹������
z = x + sqrt(R)*randn(sz); 

% ��ʼ������
state_kalman = zeros(sz); 
% ���¶ȵĹ���ֵ������kʱ�̣�����¶ȼƵ�ǰ����ֵ��k-1ʱ��Ԥ��ֵ���õ������չ���ֵ
variance_kalman = zeros(sz);            % ����ֵ�ķ���
state_pre = zeros(sz);                       % ���¶ȵ�Ԥ��
variance_pre = zeros(sz);                  % Ԥ��ֵ�ķ���
K = zeros(sz);                                   % ����������
state_kalman(1) = T_start;               %�¶ȹ���ֵ��ʼ��
variance_kalman(1) = delta_start;    %����ֵ�����ʼ��

%��ʼ�������㣨���зֱ��Ӧ�����ʽ��
for k = 2 : n_iter
    % ����һʱ�̵�����״̬����ֵ����Ϊ�Ե�ǰʱ�̵��¶ȵ�Ԥ��
    state_pre(k) = state_kalman(k-1);
    % Ԥ��ķ���Ϊ��һʱ���¶����Ź���ֵ�ķ������˹��������֮��
    variance_pre(k) = variance_kalman(k-1) + Q;
    % ���㿨��������
    K(k) = variance_pre(k)/( variance_pre(k) + R ); 
    % ��ϵ�ǰʱ���¶ȼƵĲ���ֵ������һʱ�̵�Ԥ�����У�����õ�У��������Ź��ơ�������ֱ�Ӳ�������CΪ1.
    state_kalman(k) = state_pre(k) + K(k) * (z(k) - state_pre(k)); 
    % �������չ���ֵ�ķ���������һ�ε���
    variance_kalman(k) = (1 - K(k)) * variance_pre(k);
end

%-----------------------------------------------------------------------------------------------------
%��ͼ���
LineWidth=2;
figure;
plot(z,'k+'); %�����¶ȼƵĲ���ֵ
hold on;
plot(state_kalman,'b-','LineWidth',LineWidth) %�������Ź���ֵ
hold on;
plot(x*ones(sz),'g-','LineWidth',LineWidth); %������ʵֵ
legend('�¶Ȳ���ֵ', 'Kalman����ֵ', '��ʵֵ');
hold off;

% �����������ı仯���
figure;
valid_iter = [2 : n_iter]; % variance_pre not valid at step 1
plot(valid_iter,variance_kalman([valid_iter]),'LineWidth',LineWidth); %�������Ź���ֵ�ķ���
legend('Kalman���Ƶ�������');








