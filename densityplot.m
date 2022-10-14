clear;
Data=xlsread('outliers.xlsx','B2:AD403');
ZY2=Data(:,29);

PntSet1=[Data(:,29),Data(:,29)];
PntSet2=[Data(:,29),Data(:,29)];
% PntSet3=mvnrnd([8 9],[1 0;0 1],800);

PntSet=[PntSet1;PntSet2];
colorList=[0.9300    0.9500    0.9700
    0.7900    0.8400    0.9100
    0.6500    0.7300    0.8500
    0.5100    0.6200    0.7900
    0.3700    0.5100    0.7300
    0.2700    0.4100    0.6300
    0.2100    0.3200    0.4900
    0.1500    0.2200    0.3500
    0.0900    0.1300    0.2100
    0.0300    0.0400    0.0700];

[~,~,XMesh,YMesh,ZMesh,colorList]=density2C(PntSet(:,1),PntSet(:,2),0.55:0.05:0.95,0.55:0.05:0.95,colorList);
CData=density2C(PntSet(:,1),PntSet(:,2),0.55:0.05:0.95,0.55:0.05:0.95,colorList);

set(gcf,'Color',[1 1 1]);
% 主分布图
ax1=axes('Parent',gcf);hold(ax1,'on')
colormap(colorList)
contourf(XMesh,YMesh,ZMesh,10,'EdgeColor','none')
% scatter(ax1,PntSet(:,1),PntSet(:,2),'filled','CData',CData);
ax1.Position=[0.1,0.1,0.6,0.6];
ax1.TickDir='out';

% X轴直方图
ax2=axes('Parent',gcf);hold(ax2,'on')
[f,xi]=ksdensity(PntSet(:,1));
fill([xi,xi(1)],[f,0],[0.34 0.47 0.71],'FaceAlpha',...
    0.3,'EdgeColor',[0.34 0.47 0.71],'LineWidth',1.2)
ax2.Position=[0.1,0.75,0.6,0.15];
ax2.YColor='none';
ax2.XTickLabel='';
ax2.TickDir='out';
ax2.XLim=ax1.XLim;

% Y轴小提琴图
ax3=axes('Parent',gcf);hold(ax3,'on')
violinChart(gca,1,PntSet(:,2),[0.34 0.47 0.71],0.7);
scatter(PntSet(:,2),PntSet(:,2),20,'Marker','o','MarkerEdgeAlpha',0.8);
plot([-8, 10],[0.6633,0.6633],'r-.','LineWidth',1);
plot([-8, 10],[0.9085,0.9085],'r-.','LineWidth',1);
ax3.Position=[0.75,0.1,0.15,0.6];
ax3.XColor='none';
ax3.YTickLabel='';
ax3.TickDir='out';
ax3.YLim=ax1.YLim;


