#library(rgdal)
library(shinythemes)
library(leaflet)
library(colorRamps)

load("bikeWeather.RData")
nilDF<-data.frame(Location="X1ALEX",theCount=0,theWeather=0,lon=-75.7045,lat=45.4302)
thePlay<-"Play"
getDay <- function(w,d) {
    if(w == "minT") {
        theDF<-finalMerge[finalMerge$theDate==strptime(d, format="%Y-%m-%d"),c(1,3,5,7,8)]
        if(nrow(theDF)==0){
            return(nilDF)
        }
        else {
            names(theDF)[3]<-"theWeather"
            return(theDF)
        }
    }
    else if(w == "maxT") {
        theDF<-finalMerge[finalMerge$theDate==strptime(d, format="%Y-%m-%d"),c(1,3,4,7,8)]
        if(nrow(theDF)==0){
            return(nilDF)
        }
        else {
            names(theDF)[3]<-"theWeather"
            return(theDF)
        }
    }
    else {
        theDF<-finalMerge[finalMerge$theDate==strptime(d, format="%Y-%m-%d"),c(1,3,6,7,8)]
        if(nrow(theDF)==0){
            return(nilDF)
        }
        else {
            names(theDF)[3]<-"theWeather"
            return(theDF)
        }
    }
}

getPal <- function(w) {
    if(w == "minT") {
        return(colorNumeric(palette=blue2red(10),domain=finalMerge$minTemp))
    }
    else if(w == "maxT") {
        return(colorNumeric(palette=blue2red(10),domain=finalMerge$maxTemp))
    }
    else {
        return(colorBin(palette=blue2red(6),bins=c(0,0.001,5,10,15,20,100),domain=finalMerge$totPrecip))
    }
}

getPalRange <- function(w) {
    if(w == "minT") {
        return(list("aRange"=finalMerge$minTemp,"aTitle"="Daily Minimum Temperature - Celsius"))
    }
    else if(w == "maxT") {
        return(list("aRange"=finalMerge$maxTemp,"aTitle"="Daily Maximum Temperature - Celsius"))
    }
    else {
        return(list("aRange"=finalMerge$totPrecip,"aTitle"="Daily Total Precipitation - mms"))
    }
}

day<-getDay("minT","2013-07-01")
palW<-getPal("minT")
palRange<-getPalRange("minT")