%% �Ӻ��� �ֿ麯����tΪÿ��ı߳���IΪҪ�ֿ��ͼ��numΪ���صڼ����
function fv=fenkuai(t,I,num)
[~,N]=size(I);
N=N/t;                 %N=960/4��N=240
x=floor(num/N)+1;      %�ڼ����У�    ����4��R��1��x=
y=mod(num,N);          %�ڼ�����
if y==0
    x=x-1;
    y=N;
end
fv=I(t*(x-1)+1:t*x,t*(y-1)+1:t*y);


