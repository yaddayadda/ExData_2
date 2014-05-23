library(plyr)
library(ggplot2)
library(labeling)
library(gridExtra)

## Read the data (hoping the files are in the current working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Merge the two files
newset<-merge(NEI,SCC,by.x="SCC",by.y="SCC")

# Obtain data points only containing "Mobile - On-Road".
# Please note by this Mobile - Non-Road and other mobile types are discarded 
mobileDatIndex<-grep("Mobile - On-Road ",newset$EI.Sector)
motorDat<-newset[mobileDatIndex,]
motorDat<-motorDat[motorDat$fips=="24510",]
byYear<-ddply(motorDat,.(year),summarize,sum=sum(Emissions,na.rm=TRUE),.drop=TRUE)

# Plot the sum of emissions from motor vehicles in Baltimore City per year
plot<-ggplot(byYear,aes(x=year,y=sum))+geom_point()+geom_line(linetype="dashed")

# Add x and y axis labels
plot<-plot+ylab("Total PM2.5 Emissions from motor vehicle sources(in Tons)")+xlab("Year")

# Mark the data points
plot<-plot+geom_text(hjust=1,vjust=1,aes(label=round(sum,1)))

# Add title
g <- arrangeGrob(plot,
                 main = textGrob("Total PM2.5 Emissions in Baltimore for motor vehicle sources",
                                 vjust=1))
# print on screen to check
print(g)

# Save the file 
ggsave("plot5.png", g)