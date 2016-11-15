library(shinythemes)
library(ggplot2)
library(plyr)
library(ggmap)
library(sp)
library(leaflet)
library(rgdal)
library(reshape2)

load("theNoise.RData")
load("zoomLink.RData")

factpal <- colorNumeric(rev(heat.colors(5)), domain = NULL)

#seq.Date(as.Date("2015-07-08"),as.Date("2015-07-19"),by="day")

#getWard <- function(sel) {
#    return(ifelse(sel==2,barMelt12,ifelse(sel==3,barMelt14,barMelt)))
#}

#ward <- getWard(1)
we<-barMelt
we$date<-strptime(barMelt$charDate,format="%Y-%m-%d")
we$day<-strptime(barMelt$charDate,format="%Y-%m-%d")$wday+1
we<-we[we$day %in% c(1,7),]
we$y<-0
names(barMelt)[2] <- "BylawOfficerStatus"
names(barMelt12)[2] <- "BylawOfficerStatus"
names(barMelt14)[2] <- "BylawOfficerStatus"
p1 <- ggplot(barMelt, aes(as.Date(charDate), value)) + geom_line(aes(colour = BylawOfficerStatus)) + geom_point(data=we,aes(x=as.Date(date),y=y))
p2 <- ggplot(barMelt12, aes(as.Date(charDate), value)) + geom_line(aes(colour = BylawOfficerStatus)) + geom_point(data=we,aes(x=as.Date(date),y=y))
p3 <- ggplot(barMelt14, aes(as.Date(charDate), value)) + geom_line(aes(colour = BylawOfficerStatus))+ geom_point(data=we,aes(x=as.Date(date),y=y))

theP <- list(p1,p2,p3)
thePMax <- c(max(barMelt$value)+10,max(barMelt12$value)+10,max(barMelt14$value)+10)


names(barMelt2016)[2] <- "TYPE"