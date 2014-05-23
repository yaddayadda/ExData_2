library(plyr)
library(gridExtra)
library(ggplot2)
library(labeling)

## Read the data (hoping the files are in the current working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Merge the two files
newset<-merge(NEI,SCC,by.x="SCC",by.y="SCC")

# Obtain data points only containing "Coal" (Please not charcoal is discarded here)
coalDatIndex<-grep(" Coal ",newset$Short.Name)
coalDat<-newset[x,]

# Calculate the sum of emissions per year for the coal sources (in million tons)
byYear<-ddply(NEI,.(year),summarize,sum=sum(Emissions,na.rm=TRUE)/1000000,.drop=TRUE)

# Plot the sum of emissions from coal sources each year across united states
plot<-ggplot(byYear,aes(x=year,y=sum))+geom_point()+geom_line(linetype="dashed")

# Add X and Y axis labels
plot<-plot+ylab("Total PM2.5 Emissions from Coal (in million Tons)")+xlab("Year")

# Mark the data points
plot<-plot+geom_text(hjust=1,vjust=1,aes(label=round(sum,2)))

# Add the Title for the plot
g <- arrangeGrob(plot,
                 main = textGrob("Total PM2.5 Emissions from coal combustion-related sources in United States",
                                 vjust=1))

# print the graph to screen to check
print(g)

# Save the graph as png file
ggsave("plot4.png", g)