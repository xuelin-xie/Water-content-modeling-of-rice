figure(1)
x=[0.6,1];
plot(x,x,'r','LineWidth',2);
hold on
scatter(Actualy1,Ly1,'Marker','o')
hold on
xlabel('Observed');
ylabel('Predicted');
set(gca,'FontSize',22);
title('Training results of MLR','FontSize',26);
[r,p]=corr(Actualy1,Ly1)

figure(2)
x=[0.6,1];
plot(x,x,'r','LineWidth',2);
hold on
scatter(Actualy1,By1,'Marker','s')
hold on
xlabel('Observed');
ylabel('Predicted');
set(gca,'FontSize',22);
title('Training results of BPR','FontSize',26);
[r,p]=corr(Actualy1,By1)

figure(3)
x=[0.6,1];
plot(x,x,'r','LineWidth',2);
hold on
scatter(Actualy1,Ry1,'Marker','<')
hold on
xlabel('Observed');
ylabel('Predicted');
set(gca,'FontSize',22);
title('Training results of RFR','FontSize',26);
[r,p]=corr(Actualy1,Ry1)

figure(4)
x=[0.6,1];
plot(x,x,'r','LineWidth',2);
hold on
scatter(Actualy1,Sy1,'Marker','>')
hold on
xlabel('Observed');
ylabel('Predicted');
set(gca,'FontSize',22);
title('Training results of SVR','FontSize',26);
[r,p]=corr(Actualy1,Sy1)

figure(5)
x=[0.6,1];
plot(x,x,'r','LineWidth',2);
hold on
scatter(Actualy2,Ly2,'Marker','o')
hold on
xlabel('Observed');
ylabel('Predicted');
set(gca,'FontSize',22);
title('Test results of MLR','FontSize',26);
[r,p]=corr(Actualy2,Ly2);

figure(6)
x=[0.6,1];
plot(x,x,'r','LineWidth',2);
hold on
scatter(Actualy2,By2,'Marker','s')
hold on
xlabel('Observed');
ylabel('Predicted');
set(gca,'FontSize',22);
title('Test results of BPR','FontSize',26);
[r,p]=corr(Actualy2,By2)

figure(7)
x=[0.6,1];
plot(x,x,'r','LineWidth',2);
hold on
scatter(Actualy2,Ry2,'Marker','<')
hold on
xlabel('Observed');
ylabel('Predicted');
set(gca,'FontSize',22);
title('Test results of RFR','FontSize',26);
[r,p]=corr(Actualy2,Ry2)

figure(8)
x=[0.6,1];
plot(x,x,'r','LineWidth',2);
hold on
scatter(Actualy2,Sy2,'Marker','>')
hold on
xlabel('Observed');
ylabel('Predicted');
set(gca,'FontSize',22);
title('Test results of SVR','FontSize',26);
[r,p]=corr(Actualy2,Sy2)

