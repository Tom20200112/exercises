%% MATLAB Version: 2013a
clc, clear all, close all
% 读入人口数据（1971－2000年）
Y=[33815	33981	34004	34165	34212	34327	34344	34458	34498	34476	34483	34488	34513	34497	34511	34520	34507	34509	34521	34513	34515	34517	34519	34519	34521	34521	34523	34525	34525	34527];
% 读入时间变量数据（t＝年份－1970）
T=[1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30];
% 线性化处理
for t = 1:30 
   x(t)=exp(-t);
   y(t)=1/Y(t);
end
% 计算，并输出回归系数B
c=zeros(30,1)+1;
X=[c,x'];
B=inv(X'*X)*X'*y';
for i=1:30
% 计算回归拟合值    
    z(i)=B(1,1)+B(2,1)*x(i);
% 计算离差
    s(i)=y(i)-sum(y)/30;
% 计算误差    
    w(i)=z(i)-y(i);
end
% 计算离差平方和S
S=s*s';
% 回归误差平方和Q
Q=w*w';
% 计算回归平方和U
U=S-Q;
% 计算，并输出F检验值
F=28*U/Q;
% 计算非线性回归模型的拟合值
for j=1:30
    Y1(j)=1/(B(1,1)+B(2,1)*exp(-j));
end
% 输出非线性回归模型的拟合曲线（Logisic曲线）
figure
h1=plot(T,Y,'k*');
set(gca,'linewidth',2);
set(h1,'MarkerSize',8);
xlabel('时间/年', 'fontsize',12);
ylabel('人口/人', 'fontsize',12);

figure
h2=plot( T, Y1,'--k*',...
    'LineWidth',2); 
set(gca,'linewidth',2);
set(h2,'MarkerSize',8);
xlabel('时间/年', 'fontsize',12);
ylabel('人口/人', 'fontsize',12);


