clear;clc;
I=imread('���ܺ��lena.bmp','bmp');           %��ȡͼ����Ϣ
[M,N]=size(I);                      %��ͼ������и�ֵ��M,N
t=4;    %�ֿ��С
SUM=M*N;
%% 2.����Logistic��������
% u=3.990000000000001; %��Կ�����Բ���  10^-15
u=3.99;%Logistic������
% x0=0.3711000000000001; %��Կ�����Բ���  10^-16
x0=0.3711; %Logistic��ֵx0
p=zeros(1,SUM+1000);
p(1)=x0;
for i=1:SUM+999                        %����N-1��ѭ��
    p(i+1)=u*p(i)*(1-p(i));          %ѭ����������
end
p=p(1001:length(p));

%% 3.��p���б任��0~255��Χ��������ת����M*N�Ķ�ά����R
p=mod(ceil(p*10^3),256);
R=reshape(p,N,M)';  %ת��M��N��

%% 4.�Ľ����������
%���ĸ���ֵX0,Y0,Z0,H0
r=(M/t)*(N/t);
X0=0.5001000000000001;
Y0=0.5130;
Z0=0.5170;
H0=0.3237;
A=chen_output(X0,Y0,Z0,H0,r);
X=A(:,1);
X=X(1502:length(X));
Y=A(:,2);
Y=Y(1502:length(Y));
Z=A(:,3);
Z=Z(1502:length(Z));
H=A(:,4);
H=H(1502:length(H));

%% 5.DNA����
%X,Y�ֱ����I��R��DNA���뷽ʽ����8�֣�1~8
X=mod(floor(X*10^4),8)+1;
Y=mod(floor(Y*10^4),8)+1;
Z=mod(floor(Z*10^4),3);
Z(Z==0)=3;
Z(Z==1)=0;
Z(Z==3)=1;
H=mod(floor(H*10^4),8)+1;
e=N/t;
for i=r:-1:2
    Q1=DNA_bian(fenkuai(t,I,i),H(i));
    Q1_last=DNA_bian(fenkuai(t,I,i-1),H(i-1));
    Q2=DNA_yunsuan(Q1,Q1_last,Z(i));        %��ɢǰ

    Q3=DNA_bian(fenkuai(t,R,i),Y(i));
    Q4=DNA_yunsuan(Q2,Q3,Z(i));
    xx=floor(i/e)+1;
    yy=mod(i,e);
    if yy==0
        xx=xx-1;
        yy=e;
    end
    Q((xx-1)*t+1:xx*t,(yy-1)*t+1:yy*t)=DNA_jie(Q4,X(i));
end
Q5=DNA_bian(fenkuai(t,I,1),H(1));
Q6=DNA_bian(fenkuai(t,R,1),Y(1));
Q7=DNA_yunsuan(Q5,Q6,Z(1));
Q(1:t,1:t)=DNA_jie(Q7,X(1));
Q=uint8(Q);
imwrite(Q,'���ܺ��lena.bmp','bmp');      
disp('���ܳɹ�');  
imshow(Q);