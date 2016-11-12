library(translate)
library(dplyr)

###
#Set working directory
###
setwd("../ODIOttawa/Seoul")

###
#Read Subway data in
###

subUsage<-read.csv("SepSubwayuse.csv",stringsAsFactors = FALSE)
subStation<-read.csv("SSlocations.csv",stringsAsFactors = FALSE)

###
#Set API key for Google API
###

set.key( "Your Google Translate API Key" )

###
#Translate column names and remove spaces from column names
###

names(subUsage)<-unlist(lapply(X=names(subUsage),function(x) translate(x,"ko","en")))
names(subUsage)<-unlist(lapply(X=names(subUsage),function(x) gsub(" ","",x)))

###
#Set column names to easier to manipulate names
###

newColNames<-c("month","subwayline","station","04to05on","04to05off",
               "05to06on","05to06off",
               "06to07on","06to07off",
               "07to08on","07to08off",
               "08to09on","08to09off",
               "09to10on","09to10off",
               "10to11on","10to11off",
               "11to12on","11to12off",
               "12to13on","12to13off",
               "13to14on","13to14off",
               "14to15on","14to15off",
               "15to16on","15to16off",
               "16to17on","16to17off",
               "17to18on","17to18off",
               "18to19on","18to19off",
               "19to20on","19to20off",
               "20to21on","20to21off",
               "21to22on","21to22off",
               "22to23on","22to23off",
               "23to24on","23to24off",
               "00to01on","00to01off",
               "01to02on","01to02off",
               "02to03on","02to03off",
               "03to04on","03to04off","workdate")

names(subUsage)<-newColNames

###
#Translate Subway Line and Subway Station columns
###

subUsage[,2]<-unlist(sapply(subUsage[,2],function(x) translate(x,"ko","en")))
subUsage[,3]<-unlist(sapply(subUsage[,3],function(x) translate(x,"ko","en")))

###
#Save subUsage dataframe to save on translation calls
###

save(subUsage,file="subwaySeoul.RData")

###
#Load subUsage dataframe
###

load("subwaySeoul.RData")

romanStationNames<-c("Pangyo","Imae","Samdong","Gyeonggi Gwangju","Chowol",
                      "Gonjiam","Sindundoyechon","Icheon","Bubal",
                      "Sejongdaewangneung","Yeoju")

###
#create selection vectors for passengers getting off subway columns and passengers
#getting on subway columns
###

offVector<-c(5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51)
onVector<-c(4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50)

###
#Select data for Pangyo station and store in dataframe
###

offCount<-subUsage[subUsage$station=="Pangyo",offVector] %>%
    t() %>%
    cbind(seq(1,24)) %>%
    as.data.frame()

row.names(offCount)<-NULL
colnames(offCount)<-c("passengersOff","operatingHour")

onCount<-subUsage[subUsage$station=="Pangyo",onVector] %>%
    t() %>%
    cbind(seq(1,24)) %>%
    as.data.frame()

row.names(onCount)<-NULL
colnames(onCount)<-c("passengersOn","operatingHour")

###
#Use brush tool to select Pangyo data. Example: morning rush data
#You can find source for Shiny Brush Gadget at: 
#https://github.com/rstudio/webinars/blob/master/29-Shiny-Gadgets/brush-gadget.R
###

PangyoMorningArrivals<-pick_points(offCount,~operatingHour,~passengersOff)

PangyoEveningDepartures<-pick_points(onCount,~operatingHour,~passengersOn)

#save(PangyoMorningArrivals,PangyoEveningDepartures,file="ArrDep.RData")

###
#Heatmap to explore station arrival statistics
###
library(d3heatmap)
library(tidyr)

#create dataframe for Gyeonggang Line stations
offDF <- subUsage[subUsage$subwayline=="Gyeonggangseon",append(3,offVector)]
offDF$station <- romanStationNames

offMatrix <- offDF[,-1] %>%
    data.matrix()
row.names(offMatrix)<-romanStationNames

aggOff<-offDF %>%
    gather(key = timeOfDay, value = peopleCount, -station) %>%
    aggregate(peopleCount~station,data=.,sum)


morningMatrix<-offMatrix[,PangyoMorningArrivals]

d3heatmap(morningMatrix,dendrogram = "none",colors="YlOrRd",
          xaxis_font_size="12px",yaxis_font_size="10px")
###
#Heatmap to explore station arrival statistics
###

#create dataframe for Gyeonggang Line stations

onDF <- subUsage[subUsage$subwayline=="Gyeonggangseon",append(3,onVector)]
onDF$station <- romanStationNames

onMatrix <- onDF[,-1] %>%
    data.matrix()
row.names(onMatrix)<-romanStationNames

aggOn<-onDF %>%
    gather(key = timeOfDay, value = peopleCount, -station) %>%
    aggregate(peopleCount~station,data=.,sum)


eveningMatrix<-onMatrix[,PangyoEveningDepartures]
d3heatmap(eveningMatrix,dendrogram = "none",colors="YlOrRd",
          xaxis_font_size="12px",yaxis_font_size="10px")
###
#Map of Gyeonggang Line Stations
###
library(leaflet)

###
#Get the Gyeonggang Line Stations location data
###


KKStations<-subStation[subStation$Line=="KK",]
KKStations<-KKStations[order(KKStations$External.Code,decreasing = FALSE),]
KKStations$romanStation<-romanStationNames
KKStations<-merge(KKStations,aggOff,by.x="romanStation",by.y="station")

###
#Manually assign Yeoju station coordinates
###

KKStations$X.WGS[11]<-37.282882
KKStations$Y.WGS[11]<-127.628672

###
#Plot Gyeonggang Line stations on map
###

popup<-paste(sep = "<br/>",
            paste0("<b>","Station","</b>"),
            paste0("Hangul: ",KKStations$Station),
            paste0("Roman: ",KKStations$romanStation),
            paste0("Passenger Arrivals: ",KKStations$peopleCount))
             

leaflet(KKStations)%>% setView(lng = 127.268109, lat = 37.299880, zoom = 10) %>% addTiles() %>%
    addCircles(lng = ~Y.WGS, lat = ~X.WGS, weight = 1,color="Black",fillColor = "Yellow",
               fillOpacity = 0.8,radius = 1000, popup = popup)

leaflet(KKStations)%>% setView(lng = 127.268109, lat = 37.299880, zoom = 10) %>% addTiles() %>%
    addCircles(lng = ~Y.WGS, lat = ~X.WGS, weight = 1,color="Black",fillColor = "Yellow",
               fillOpacity = 0.8,radius = ~sqrt(peopleCount)*10, 
               popup = popup)
