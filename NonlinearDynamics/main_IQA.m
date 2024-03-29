%% 图像质量评价——均方误差（Mean Square Error,MSE）、峰值信噪比（Peak-Signal to Noise Ratio,PSNR）
clear;clc;
I=imread('F:\Users\Revere\Desktop\NonliearDynamics\LaTeX_DL_468198_220518\fig2/decry-living.png','png');           %读取图像信息
[M,N]=size(I(:,:,1));                      %将图像的行列赋值给M,N
t=4;    %分块大小
M1=0;   %加密时补零的参数，M1=mod(M,t);作为密钥
N1=0;   %加密时补零的参数，N1=mod(N,t);作为密钥
SUM=M*N;
I=imnoise(I,'salt & pepper',0.1);         %加入10%的椒盐噪声
imshow(I);
%加入高斯噪声，用于图像质量评价

%% 产生Logistic混沌序列
u=3.991;%Logistic参数μ
x0=0.5841; %Logistic初值x0
p=zeros(1,SUM+1000);
p(1)=x0;
for i=1:SUM+999                        %进行N-1次循环
    p(i+1)=u*p(i)*(1-p(i));          %循环产生密码
end
p=p(1001:length(p));

%% 将p序列变换到0~255范围内整数，转换成M*N的二维矩阵R
p=mod(ceil(p*10^3),256);
R=reshape(p,N,M)';  %转成M行N列

%% 求解混沌方程
%求四个初值X0,Y0,Z0,H0
r=(M/t)*(N/t);
X0=0.5069;
Y0=0.4986;
Z0=0.4939;
H0=0.6132;
A=chen_output(X0,Y0,Z0,H0,r);
X=A(:,1);
X=X(1502:length(X));
Y=A(:,2);
Y=Y(1502:length(Y));
Z=A(:,3);
Z=Z(1502:length(Z));
H=A(:,4);
H=H(1502:length(H));

 %X,Y分别决定I和R的DNA编码方式，有8种，1~8
X=mod(floor(X*10^4),8)+1;
Y=mod(floor(Y*10^4),8)+1;
Z=mod(floor(Z*10^4),3);
Z(Z==0)=3;
Z(Z==1)=0;
Z(Z==3)=1;
H=mod(floor(H*10^4),8)+1;
e=N/t;
%% 图像质量评价
YY=imread('F:\Users\Revere\Desktop\NonliearDynamics\LaTeX_DL_468198_220518\fig2/living.png','png');        %读取图像信息
YY=double(YY);
Y1=YY(:,:,1);        %R
Y2=YY(:,:,2);        %G
Y3=YY(:,:,3);        %B
MSE_R=zeros(1,21);MSE_G=zeros(1,21);MSE_B=zeros(1,21);
j=0;        %数组下标
for i=0:5:100
   % I = imnoise(I, 'gaussian', 0, i^2/255^2);  %加入高斯白噪声
    I1=I(:,:,1);     %R通道
    I2=I(:,:,2);     %G通道
    I3=I(:,:,3);     %B通道
    j=j+1;      %数组下标

    %% DNA编码（解密）
    for ii=r:-1:2
        Q1_R=DNA_bian(fenkuai(t,I1,ii),H(ii));
        Q1_G=DNA_bian(fenkuai(t,I2,ii),H(ii));
        Q1_B=DNA_bian(fenkuai(t,I3,ii),H(ii));

        Q1_last_R=DNA_bian(fenkuai(t,I1,ii-1),H(ii-1));
        Q1_last_G=DNA_bian(fenkuai(t,I2,ii-1),H(ii-1));
        Q1_last_B=DNA_bian(fenkuai(t,I3,ii-1),H(ii-1));

        Q2_R=DNA_yunsuan(Q1_R,Q1_last_R,Z(ii));        %扩散前
        Q2_G=DNA_yunsuan(Q1_G,Q1_last_G,Z(ii));
        Q2_B=DNA_yunsuan(Q1_B,Q1_last_B,Z(ii));

        Q3=DNA_bian(fenkuai(t,R,ii),Y(ii));

        Q4_R=DNA_yunsuan(Q2_R,Q3,Z(ii));
        Q4_G=DNA_yunsuan(Q2_G,Q3,Z(ii));
        Q4_B=DNA_yunsuan(Q2_B,Q3,Z(ii));

        xx=floor(ii/e)+1;
        yy=mod(ii,e);
        if yy==0
            xx=xx-1;
            yy=e;
        end
        Q_R((xx-1)*t+1:xx*t,(yy-1)*t+1:yy*t)=DNA_jie(Q4_R,X(ii));
        Q_G((xx-1)*t+1:xx*t,(yy-1)*t+1:yy*t)=DNA_jie(Q4_G,X(ii));
        Q_B((xx-1)*t+1:xx*t,(yy-1)*t+1:yy*t)=DNA_jie(Q4_B,X(ii));
    end
    Q5_R=DNA_bian(fenkuai(t,I1,1),H(1));
    Q5_G=DNA_bian(fenkuai(t,I2,1),H(1));
    Q5_B=DNA_bian(fenkuai(t,I3,1),H(1));

    Q6=DNA_bian(fenkuai(t,R,1),Y(1));

    Q7_R=DNA_yunsuan(Q5_R,Q6,Z(1));
    Q7_G=DNA_yunsuan(Q5_G,Q6,Z(1));
    Q7_B=DNA_yunsuan(Q5_B,Q6,Z(1));

    Q_R(1:t,1:t)=DNA_jie(Q7_R,X(1));
    Q_G(1:t,1:t)=DNA_jie(Q7_G,X(1));
    Q_B(1:t,1:t)=DNA_jie(Q7_B,X(1));
    
    Q1=Q_R;
    Q2=Q_G;
    Q3=Q_B;
    
    %去除加密时补的零
    if M1~=0
        Q1=Q1(1:M-t+M1,:);
        Q2=Q2(1:M-t+M1,:);
        Q3=Q3(1:M-t+M1,:);
    end
    if N1~=0
        Q1=Q1(:,1:N-t+N1);
        Q2=Q2(:,1:N-t+N1);
        Q3=Q3(:,1:N-t+N1);
    end
    [MM,NN]=size(Q1);     %重新获得解密后的图片大小
    for m=1:MM
        for n=1:NN
            MSE_R(j)=MSE_R(j)+(Y1(m,n)-Q1(m,n))^2;       %R通道MSE
            MSE_G(j)=MSE_G(j)+(Y2(m,n)-Q2(m,n))^2;       %G通道MSE
            MSE_B(j)=MSE_B(j)+(Y3(m,n)-Q3(m,n))^2;       %B通道MSE
        end
    end
    RESULT(:,:,1)=uint8(Q_R);
    RESULT(:,:,2)=uint8(Q_G);
    RESULT(:,:,3)=uint8(Q_B);
%     figure;imshow(RESULT);title(['高斯噪声方差为',num2str(i),'时的解密图像']);
end
figure;imshow(RESULT);title(['高斯噪声方差为',num2str(i),'时的解密图像']);
%噪声功率-MSE
MSE_R=MSE_R./SUM;
MSE_G=MSE_G./SUM;
MSE_B=MSE_B./SUM;
%峰值信噪比-PSNR
PSNR_R=10*log10((255^2)./MSE_R);
PSNR_G=10*log10((255^2)./MSE_G);
PSNR_B=10*log10((255^2)./MSE_B);
%% 绘图，噪声功率-MSE、峰值信噪比-PSNR
X=0:5:100;
figure;plot(X,MSE_R);set(gca,'xtick', X);xlabel('高斯噪声方差');ylabel('均方误差MSE');title('R通道：高斯噪声方差-均方误差MSE曲线图');
figure;plot(X,MSE_G);set(gca,'xtick', X);xlabel('高斯噪声方差');ylabel('均方误差MSE');title('G通道：高斯噪声方差-均方误差MSE曲线图');
figure;plot(X,MSE_B);set(gca,'xtick', X);xlabel('高斯噪声方差');ylabel('均方误差MSE');title('B通道：高斯噪声方差-均方误差MSE曲线图');
figure;plot(X,PSNR_R);set(gca,'xtick', X);xlabel('高斯噪声方差');ylabel('峰值信噪比PSNR（dB）');title('R通道：高斯噪声方差-峰值信噪比PSNR曲线图');
figure;plot(X,PSNR_G);set(gca,'xtick', X);xlabel('高斯噪声方差');ylabel('峰值信噪比PSNR（dB）');title('G通道：高斯噪声方差-峰值信噪比PSNR曲线图');
figure;plot(X,PSNR_B);set(gca,'xtick', X);xlabel('高斯噪声方差');ylabel('峰值信噪比PSNR（dB）');title('B通道：高斯噪声方差-峰值信噪比PSNR曲线图');