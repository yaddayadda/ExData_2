library(plyr)

## Read the data (hoping the files are in the current working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Calculate the sum of different emissions per year
## The values are scaled in million tons
results<-ddply(NEI,.(year),summarize,sum=sum(Emissions,na.rm=TRUE)/1000000,.drop=TRUE)

# Set the graph device settings
png(file="plot1.png" , height=480 , width=480 , units="px", bg = "white")
par(mar=c(4.1, 4.1, 2, 0.5))

# Plot sum of emissions per year
plot(y=results$sum,x=results$year,type='b',lty=3,xlab="Year",ylab="Total PM2.5 Emissions (million tons)")
text(x=results$year,y=results$sum,labels=round(results$sum,1),pos=1,color="blue")
title(main="Total PM2.5 Emissions in United States")
title(sub = paste0("Note: PM2.5 Emissions for all sources reduced from ",round(results$sum[results$year=="1999"],2)," to ",round(results$sum[results$year=="2008"],2)," million tons from 1999-2008"), cex.sub = 0.75, adj = 0)

# Close the graphic device
dev.off()