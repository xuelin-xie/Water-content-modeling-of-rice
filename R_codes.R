#install.packages("corrplot")
#install.packages("viridis")
data<-read.csv("outliers.csv",header = T,row.names=NULL) 
summary(data$WC[1:402])

##Figure 3
library(viridis)
library(corrplot)
data<-read.csv("example2.csv",header = T,row.names=NULL) 
res<-cor(data[,2:30])
corr<-cor.mtest(data[,2:30])
colnames(res) <- assign(data[0,2:30])
rownames(res) <- assign(data[0,2:30])
color<-viridis(100)
corrplot(res, tl.col ="black",order = "hclust",method="ellipse", col=color,
         p.mat=corr$p,insig = "blank",tl.cex=1, 
         rect.col="red")


library(viridis)
library("corrplot")
data<-read.csv("corr.csv",header = T,row.names=NULL) 
res<-cor(data[,2:21])
corr<-cor.mtest(data[,2:21])
colnames(res) <- assign(data[0,2:21])
rownames(res) <- assign(data[0,2:21])
corrplot(res, tl.col ="black",order = "hclust",method="number", col="#0000CD",
         p.mat=corr$p,insig = "blank",addrect = 13,tl.cex=1,rect.col="#7D26CD",rect.lwd=4)


##Figure 4
#install.packages("BiocManager")
#BiocManager::install("ggtree")
library(ggtree)
library(ggplot2)
data<-read.csv("hclust.csv",header = T,row.names=NULL)
df <- scale(data[1:401,2:14])
#install.packages("factoextra")
library(factoextra)
fviz_nbclust(df, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)+
  labs(subtitle = "Elbow method")

rownames(df)<-paste(data$IDNumber)
hc<-hclust(dist(df),method="euclidean")
ggtree(hc,layout="circular",size=0.5)+
  geom_tiplab(offset=0.1,size=4,font=3)+
  #geom_text(aes(label=node))+
  geom_highlight(node = 403,fill="#009393")+
  geom_highlight(node=407,fill="#FFD306")+  
  geom_highlight(node=408,fill="mediumaquamarine")+
  geom_highlight(node=405,fill="midnightblue")+
  geom_cladelabel(node=403,label="A",fontsize = 25,
                  offset=2.5,barsize = 30,offset.text=1,
                  color="#009393")+
  geom_cladelabel(node=407,label="B",fontsize = 25,
                  offset=2.5,barsize = 30,offset.text=1.6,
                  color="#FFD306")+
  geom_cladelabel(node=408,label="C",fontsize = 25,
                  offset=2.5,barsize = 30,offset.text=1.4,
                  color="mediumaquamarine")+
  geom_cladelabel(node=405,label="D",fontsize = 25,
                  offset=2.5,barsize = 30,offset.text=1.5,
                  color="midnightblue")