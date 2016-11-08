library(translate)
setwd("../../ODIOttawa/Seoul")
subUsage<-read.csv("SepSubwayuse.csv",stringsAsFactors = FALSE)
subStation<-read.csv("SepSubwayuse.csv",stringsAsFactors = FALSE)
set.key( "AIzaSyDHxhrUR-yPfLbY7XlJR3rFW73qE7w1RA4" )

names(subUsage)<-unlist(lapply(X=names(subUsage),function(x) translate(x,"ko","en")))
names(subUsage)<-unlist(lapply(X=names(subUsage),function(x) gsub(" ","",x)))

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

subUsage[,2]<-unlist(sapply(subUsage[,2],function(x) translate(x,"ko","en")))
subUsage[,3]<-unlist(sapply(subUsage[,3],function(x) translate(x,"ko","en")))

save(subUsage,file="subwaySeoul.RData")

offVector<-c(5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51)
onVector<-c(4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50)

theX<-seq(1,24)