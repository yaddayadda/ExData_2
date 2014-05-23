library(plyr)
library(ggplot2)
library(labeling)
library(gridExtra)

## Read the data (hoping the files are in the current working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

newset<-merge(NEI,SCC,by.x="SCC",by.y="SCC")
mobileDatIndex<-grep("Mobile - On-Road ",newset$EI.Sector)
motorDat<-newset[mobileDatIndex,]
#6  
motorDat<-motorDat[(motorDat$fips=="24510") | (motorDat$fips=="06037"),]
byYear<-ddply(motorDat,.(year,fips),summarize,sum=round(sum(Emissions,na.rm=TRUE),1),.drop=TRUE)
byYear<-byYear[byYear$fips=="06037"]<-"Los Angeles"
byYear<-byYear[byYear$fips=="24510"]<-"Baltimore"
plot<-ggplot(byYear,aes(x=year,y=sum,group=fips,color=fips))+geom_point()+geom_line(linetype="dashed")
plot<-plot+ylab("Total PM2.5 Emissions from motor vehicle sources(in Tons)")+xlab("Year")
plot<-plot+geom_text(hjust=1,vjust=1,aes(label=round(sum,2)))

g <- arrangeGrob(plot,
                 main = textGrob("Total PM2.5 Emissions in Baltimore and LA for Motor Vehicle Sources",
                                 vjust=1))
print(g)
ggsave("plot6.png", g)