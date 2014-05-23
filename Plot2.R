library(plyr)

## Read the data (hoping the files are in the current working directory)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Calculate the Sum of Emissions per year and fips 
byfips<-ddply(NEI,.(year,fips),summarize,sum=sum(Emissions,na.rm=TRUE)/1000,.drop=TRUE)

# Pick the results for Baltimore City
results<-byfips[byfips$fips=="24510",]

# Set the graph device settings
png(file="plot2.png", height=480 , width=480 , units="px", bg = "white")
par(mar=c(4.1, 4.1, 2, 0.5))

# Plot sum of emissions per year for Baltimore City
plot(y=results$sum,x=results$year,type='b',lty=3,xlab="Year",ylab="Total PM2.5 Emissions (kilo tons)")
text(x=results$year,y=results$sum,labels=round(results$sum,2),pos=1)
title(main="Total PM2.5 Emissions in Baltimore City")

# Add a Note to point the explain the decease in emissions
title(sub = paste0("Note: PM2.5 Emissions for all sources reduced from ",round(results$sum[results$year=="1999"],2)," to ",round(results$sum[results$year=="2008"],2)," kilo tons from 1999-2008"), cex.sub = 0.75, adj = 0)

# Close the graphic device
dev.off()