Sys.setenv(TZ="America/Montreal")
library(rgdal)
library(ggplot2)
library(shinythemes)
library(leaflet)
library(plyr)
#library(ggmap)
library(sp)

load("OttawaCrime.RData")
shapeList<-list()
shapeList[[1]] <- readOGR(dsn='./CrimeWards_SHP','CrimeWards_2005',verbose=FALSE,stringsAsFactors=FALSE)
shapeList[[2]] <- readOGR(dsn='./CrimeWards_SHP','CrimeWards_2006',verbose=FALSE,stringsAsFactors=FALSE)
shapeList[[3]] <- readOGR(dsn='./CrimeWards_SHP','CrimeWards_2006',verbose=FALSE,stringsAsFactors=FALSE)
shapeList[[4]] <- readOGR(dsn='./CrimeWards_SHP','CrimeWards_2008',verbose=FALSE,stringsAsFactors=FALSE)
shapeList[[5]] <- readOGR(dsn='./CrimeWards_SHP','CrimeWards_2009',verbose=FALSE,stringsAsFactors=FALSE)
shapeList[[6]] <- readOGR(dsn='./CrimeWards_SHP','CrimeWards_2010',verbose=FALSE,stringsAsFactors=FALSE)
shapeList[[7]] <- readOGR(dsn='./CrimeWards_SHP','CrimeWards_2011',verbose=FALSE,stringsAsFactors=FALSE)
shapeList[[8]] <- readOGR(dsn='./CrimeWards_SHP','CrimeWards_2012',verbose=FALSE,stringsAsFactors=FALSE)
shapeList[[9]] <- readOGR(dsn='./CrimeWards_SHP','CrimeWards_2013',verbose=FALSE,stringsAsFactors=FALSE)

prj.LatLong <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")

for (x in 1:9){
    shapeList[[x]] <- spTransform(shapeList[[x]], prj.LatLong)
}

location<-c(-75.67724,45.29814)
factpal <- colorNumeric(rev(heat.colors(3)), domain = NULL)

getPoly <- function(theY,theCC,theStat) {
        theYear<-as.integer(theY)
        if (theCC == "total") {
        if (theStat == "total") {
            theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","total_num")]
        }
        else if(theStat=="solv"){
            theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","total_solv")]
        }
        else {
            theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","total_rate")]
        }
    }
    else if (theCC == "person") {
            if (theStat == "total") {
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","viol_num")]
            }
            else if(theStat=="solv"){
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","viol_solv")]
            }
            else {
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","viol_rate")]
            }
        } 
    else if (theCC == "prop") {
            if (theStat == "total") {
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","prop_num")]
            }
            else if(theStat=="solv"){
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","prop_solv")]
            }
            else {
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","prop_rate")]
            }
        } 
    else if (theCC == "traffic") {
            if (theStat == "total") {
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","traff_num")]
            }
            else if(theStat=="solv"){
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","traff_solv")]
            }
            else {
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","traff_rate")]
            }
        } 
        else {
            if (theStat == "total") {
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","occo_num")]
            }
            else if(theStat=="solv"){
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","occo_solv")]
            }
            else {
                theDF<-theCrime[theCrime$year == theYear,c("Ward_Number","ward_Name","population","occo_rate")]
            }
        }
    
    theDF<-na.omit(theDF)
    if (nrow(theDF)==0){return(NULL)}
    
    names(theDF)[4]<-"theNum"
    wardPoly<-shapeList[[(theYear-2004)]]
    wardPoly@data$numAmt <- 0
    if (theYear == 2013){
        for (ward in theDF$Ward_Number) {
            wardString<-paste0("Ward ",ward)
            wardPoly@data$numAmt[wardPoly@data$W_NUMBER==wardString]<-theDF$theNum[theDF$Ward_Number==ward]
        }
    }
    else {
        for (ward in theDF$Ward_Number) {
            wardPoly@data$numAmt[wardPoly@data$WARD_NUM==ward]<-theDF$theNum[theDF$Ward_Number==ward]
        }
    }

    if (theYear == 2013) {
        theDF$Ward_Number<-paste0("Ward ",theDF$Ward_Number)
        wp<-wardPoly[wardPoly@data$W_NUMBER %in% theDF$Ward_Number,]
    }
    else {
        wp<-wardPoly[wardPoly@data$WARD_NUM %in% theDF$Ward_Number,]
    }
    return(wp)
}

thePoly <-getPoly(2013,"total","total")