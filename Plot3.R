library(plyr)
library(ggplot2)
library(labeling)
library(gridExtra)

## Read the data (hoping the files are in the current working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Calculate the sum of emissions per year for each type of emissions in each fips
byfips<-ddply(NEI,.(year,fips,type),summarize,sum=sum(Emissions,na.rm=TRUE)/100,.drop=TRUE)

# Obtain the results for Baltimore City
results<-byfips[byfips$fips=="24510",]

# Add the Plot settings
par(mar=c(4.1, 4.1, 2, 0.5))

# Make a ggplot showing sum of emissions for each type per year in Baltimore city
plot<-ggplot(results,aes(x=year,y=sum,group=type,color=type))+geom_point()+geom_line(linetype="dashed")

# Add X and Y labels
plot<-plot+ylab("Total PM2.5 Emissions (Hundred Tons)")+xlab("Year")

# Mark the data points
plot<-plot+geom_text(hjust=0,vjust=0,aes(label=round(sum,2)))

# Add plot title and add a foot note
g <- arrangeGrob(plot,
                 main = textGrob("Total PM2.5 Emissions in Baltimore for different sources",
                                 vjust=1),
                 sub = textGrob("NOTE: Point emissions increased from 1999-2008. While emissions from NON-ROAD,NONPOINT and ON-ROAD decreased.",
                                x=0,hjust=-0.1,vjust=0.1,
                                gp=gpar(fontface="italic",fontsize=10)))
print(g)
ggsave("plot3.png", g)
