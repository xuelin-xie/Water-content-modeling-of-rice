clear;
clc;
setdemorandstream(1);
Data=xlsread('test.xlsx','B2:P402');
Dmean=mean(Data(:,13));
Dstd=std(Data(:,13));
Data=zscore(Data);
Z1=Data(:,1:12); %Feature selection points
ZY2=Data(:,13); %The actual values of the function at the feature selection points

%stepwise regression
p=0.01;
[B1,SE,PVAL1,INMODEL,STATS,NEXTSTEP,HISTORY]=stepwisefit(Z1,ZY2,'penter',p);

for i=1:10

%random sampling
%Class A samples
n1=randsample(59,44,'false');
A1=Data(n1,:);
c1=1:59;
c1(n1)=[];
B1=Data(c1,:);
%Class B samples
n2=randsample(126,95,'false');
A2=Data(n2+59,:);
c2=60:185;
c2(n2)=[];
B2=Data(c2,:);
%Class C samples
n3=randsample(19,14,'false');
A3=Data(n3+185,:);
c3=186:204;
c3(n3)=[];
B3=Data(c3,:);
%Class D samples
n4=randsample(197,148,'false');
A4=Data(n4+204,:);
c4=205:401;
c4(n4)=[];
B4=Data(c4,:);

%%Training and test set
A=[A1;A2;A3;A4];
B=[B1;B2;B3;B4];
X1=A(:,1:12);
X2=B(:,1:12);

new_MX1=[];new_MX2=[];
M2_Y1=A(:,13);
M2_Y2=B(:,13);
M2_X1=[PVAL1'; X1]; %Added p-value variable for filtering
M2_X2=[PVAL1'; X2]; %Added p-value variable for filtering
k=1;
for m=1:size(M2_X1,2)
    if any(M2_X1(1,m)<p)
        new_MX1(:,k)=[M2_X1(:,m)];
        new_MX2(:,k)=[M2_X2(:,m)];
        k=k+1;
    end
end

if isempty(new_MX1)==1;
    disp('Stepwise regression methods are currently not applicable');
    new_MX1=S;
    M2_X2(1,:)=[];  %remove the added p-value variable
    new_MX2=M2_X2;
    k=size(M2_X2,2)+1;
else
    new_MX1(1,:)=[];  %remove the added p-value variable
    M2_X2(1,:)=[];  %remove the added p-value variable
    new_MX2(1,:)=[];  %remove the added p-value variable
end

M2_X1=new_MX1;
M2_X2=new_MX2;

%%MLiner
[b1,bint,r,rint,stats1]=regress(M2_Y1,M2_X1);
M2_Ly1=M2_X1*b1;
M2_Ly2=M2_X2*b1;


%%BP net
input_train = M2_X1';
B_train =M2_Y1';
input_test = M2_X2';
B_test =M2_Y2';
setdemorandstream(5);
hiddennum=7; 
outputnum=1;
[inputn,inputps]=mapminmax(input_train,0,1);
[outputn,outputps]=mapminmax(B_train);
net=newff(inputn,outputn,hiddennum,{'tansig','purelin'},'trainbr');
W1= net. iw{2, 1};
B11 = net.b{2};
W2 = net.lw{2,1};
B12 = net. b{2};
net.trainParam.epochs=1000;        
net.trainParam.lr=0.01;                   
net.trainParam.goal=0.0001;                    
net=train(net,inputn,outputn);
inputn_test=mapminmax('apply',input_test,inputps);
Bn1_sim=sim(net,inputn); 
Bn_sim=sim(net,inputn_test); 
M2_By1 = mapminmax('reverse',Bn1_sim,outputps);
M2_By2 =mapminmax('reverse',Bn_sim,outputps); 

%%SVR
[bestmse,bestc,bestg]=SVMcgForRegress(M2_Y1,M2_X1);
cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg),' -s 3 -t 2  -p 0.01'];
model1=svmtrain(M2_Y1,M2_X1,cmd);
[M2_Sy1,mse1]=svmpredict(M2_Y1,M2_X1,model1);
[M2_Sy2,tmse1]=svmpredict(M2_Y2,M2_X2,model1);


%%RFR
leaf = 1;
ntrees = 500;  
fboot = 1;
setdemorandstream(5);
b = TreeBagger(ntrees, M2_X1,M2_Y1, 'Method','regression', 'oobvarimp','on', 'surrogate', 'on', 'minleaf',leaf,'FBoot',fboot);
% prediction
M2_Ry1 = predict(b, M2_X1);
M2_Ry2 = predict(b, M2_X2);

Actualy1=M2_Y1*Dstd+Dmean;
Actualy2=M2_Y2*Dstd+Dmean;

Ly1=M2_Ly1*Dstd+Dmean;
Ly2=M2_Ly2*Dstd+Dmean;
LMAPE1(i)=sum(abs(Actualy1 -Ly1)./Ly1)/size(Actualy1,1);
LMAPE2(i)=sum(abs(Actualy2 -Ly2)./Ly2)/size(Actualy2,1);
LMaxAPE1(i)=max(abs(Actualy1 -Ly1)./Ly1);
LMaxAPE2(i)=max(abs(Actualy2 -Ly2)./Ly2);
LRmse1(i)=sqrt(sum((Actualy1-Ly1).*(Actualy1-Ly1)) /size(Actualy1,1));
LRmse2(i)=sqrt(sum((Actualy2-Ly2).*(Actualy2-Ly2)) /size(Actualy2,1));
Lmae1(i)=sum(abs(Actualy1-Ly1))/size(Actualy1,1);
Lmae2(i)=sum(abs(Actualy2-Ly2))/size(Actualy2,1);

By1=(M2_By1*Dstd+Dmean)';
By2=(M2_By2*Dstd+Dmean)';
BMAPE1(i)=sum(abs(Actualy1 -By1)./By1)/size(Actualy1,1);
BMAPE2(i)=sum(abs(Actualy2 -By2)./By2)/size(Actualy2,1);
BMaxAPE1(i)=max(abs(Actualy1 -By1)./By1);
BMaxAPE2(i)=max(abs(Actualy2 -By2)./By2);
BRmse1(i)=sqrt(sum((Actualy1-By1).*(Actualy1-By1)) /size(Actualy1,1));
BRmse2(i)=sqrt(sum((Actualy2-By2).*(Actualy2-By2)) /size(Actualy2,1));
Bmae1(i)=sum(abs(Actualy1-By1))/size(Actualy1,1);
Bmae2(i)=sum(abs(Actualy2-By2))/size(Actualy2,1);

Ry1=M2_Ry1*Dstd+Dmean;
Ry2=M2_Ry2*Dstd+Dmean;
RMAPE1(i)=sum(abs(Actualy1 -Ry1)./Ry1)/size(Actualy1,1);
RMAPE2(i)=sum(abs(Actualy2 -Ry2)./Ry2)/size(Actualy2,1);
RMaxAPE1(i)=max(abs(Actualy1 -Ry1)./Ry1);
RMaxAPE2(i)=max(abs(Actualy2 -Ry2)./Ry2);
RRmse1(i)=sqrt(sum((Actualy1-Ry1).*(Actualy1-Ry1)) /size(Actualy2,1));
RRmse2(i)=sqrt(sum((Actualy2-Ry2).*(Actualy2-Ry2)) /size(Actualy2,1));
Rmae1(i)=sum(abs(Actualy1-Ry1))/size(Actualy1,1);
Rmae2(i)=sum(abs(Actualy2-Ry2))/size(Actualy2,1);

Sy1=M2_Sy1*Dstd+Dmean;
Sy2=M2_Sy2*Dstd+Dmean;
SMAPE1(i)=sum(abs(Actualy1 -Sy1)./Sy1)/size(Actualy1,1);
SMAPE2(i)=sum(abs(Actualy2 -Sy2)./Sy2)/size(Actualy2,1);
SMaxAPE1(i)=max(abs(Actualy1 -Sy1)./Sy1);
SMaxAPE2(i)=max(abs(Actualy2 -Sy2)./Sy2);
SRmse1(i)=sqrt(sum((Actualy1-Sy1).*(Actualy1-Sy1)) /size(Actualy2,1));
SRmse2(i)=sqrt(sum((Actualy2-Sy2).*(Actualy2-Sy2)) /size(Actualy2,1));
Smae1(i)=sum(abs(Actualy1-Sy1))/size(Actualy1,1);
Smae2(i)=sum(abs(Actualy2-Sy2))/size(Actualy2,1);

end



LMAPE1,LMAPE2
BMAPE1,BMAPE2
RMAPE1,RMAPE2
SMAPE1,SMAPE2

LRmse1,LRmse2
BRmse1,BRmse2
RRmse1,RRmse2
SRmse1,SRmse2

%%
mean(LMAPE1);
mean(BMAPE1);
mean(RMAPE1);
mean(SMAPE1);

mean(LRmse1);
mean(BRmse1);
mean(RRmse1);
mean(SRmse1);

mean(Lmae1);
mean(Bmae1);
mean(Rmae1);
mean(Smae1);

mean(LMaxAPE1);
mean(BMaxAPE1);
mean(RMaxAPE1);
mean(SMaxAPE1);


std(LMAPE1);
std(BMAPE1);
std(RMAPE1);
std(SMAPE1);

std(LRmse1);
std(BRmse1);
std(RRmse1);
std(SRmse1);

std(Lmae1);
std(Bmae1);
std(Rmae1);
std(Smae1);

std(LMaxAPE1);
std(BMaxAPE1);
std(RMaxAPE1);
std(SMaxAPE1);

%%
mean(LMAPE2);
mean(BMAPE2);
mean(RMAPE2);
mean(SMAPE2);

mean(LRmse2);
mean(BRmse2);
mean(RRmse2);
mean(SRmse2);

mean(Lmae2);
mean(Bmae2);
mean(Rmae2);
mean(Smae2);

mean(LMaxAPE2);
mean(BMaxAPE2);
mean(RMaxAPE2);
mean(SMaxAPE2);

std(LMAPE2);
std(BMAPE2);
std(RMAPE2);
std(SMAPE2);

std(LRmse2);
std(BRmse2);
std(RRmse2);
std(SRmse2);

std(Lmae2);
std(Bmae2);
std(Rmae2);
std(Smae2);

std(LMaxAPE2);
std(BMaxAPE2);
std(RMaxAPE2);
std(SMaxAPE2);