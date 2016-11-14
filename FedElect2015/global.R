Sys.setenv(TZ="America/Montreal")
library(rgdal)
library(shinythemes)
library(leaflet)
library(networkD3)
library(tm)
library(wordcloud)


load("FedTotWin20151018.RData")
load("FedFolNet20151018.RData")
load("FedFolWin20151018.RData")
load("FedSentWin20151018.RData")

fileConn<-file("FedTo20151018.txt")
toText<-readLines(fileConn)
close(fileConn)
toText<-PlainTextDocument(toText)
toText<-removeWords(toText, stopwords("SMART"))
toText<-removeWords(toText, stopwords("french"))


fileConn<-file("FedFrom20151018.txt")
fromText<-readLines(fileConn)
close(fileConn)
fromText<-PlainTextDocument(fromText)
fromText<-removeWords(fromText, stopwords("SMART"))
fromText<-removeWords(fromText, stopwords("french"))

fWinner$riding[fWinner$riding=="Ottawa-Orleans"]<-"Orleans"
fWinner<-fWinner[order(fWinner$riding,decreasing=TRUE),]
HDWinner$riding[HDWinner$riding=="Ottawa-Orleans"]<-"Orleans"
HDWinner<-HDWinner[order(HDWinner$riding,decreasing=TRUE),]
conWinner$riding[conWinner$riding=="Ottawa-Orleans"]<-"Orleans"
conWinner<-conWinner[order(conWinner$riding,decreasing=TRUE),]
sentWinner$riding[sentWinner$riding=="Ottawa-Orleans"]<-"Orleans"
sentWinner<-sentWinner[order(sentWinner$riding,decreasing=TRUE),]

ridings <- readOGR(dsn='./ottawaRidings','ottawaRidings',verbose=FALSE,stringsAsFactors=FALSE)
ridings@data$fWin <- " "
ridings@data$HDWin <- " "
ridings@data$conWin <- " "
ridings@data$sentWin <- " "
ridings@data$Con <- " "
ridings@data$Lib <- " "
ridings@data$NDP <- " "

ridings@data$ENNAME[ridings@data$FEDNUM==35076]<-"Orleans"


#mapRiding<-data.frame(polyRiding=ridings@data$ENNAME,twitRiding=c("Nepean","Ottawa-Vanier","Ottawa West-Nepean","Ottawa-Orleans","Ottawa South","Carleton","Ottawa Centre","Kanata-Carleton"),stringsAsFactors=FALSE)


for (FN in joinFEDNUM$FEDNUM) {
    ridings@data$Con[ridings@data$FEDNUM==FN]<-tempJoin$Candidate[tempJoin$Party=="Con" & 
                                                                      tempJoin$Riding==joinFEDNUM$riding[joinFEDNUM$FEDNUM==FN]]
    ridings@data$Lib[ridings@data$FEDNUM==FN]<-tempJoin$Candidate[tempJoin$Party=="Lib" & 
                                                                      tempJoin$Riding==joinFEDNUM$riding[joinFEDNUM$FEDNUM==FN]]
    ridings@data$NDP[ridings@data$FEDNUM==FN]<-tempJoin$Candidate[tempJoin$Party=="NDP" & 
                                                                      tempJoin$Riding==joinFEDNUM$riding[joinFEDNUM$FEDNUM==FN]]
}

for (FN in fWinner$FEDNUM) {
    ridings@data$fWin[ridings@data$FEDNUM==FN]<-fWinner$party[fWinner$FEDNUM==FN]
}
ridings@data$fWin <- factor(ridings@data$fWin)

for (FN in HDWinner$FEDNUM) {
    ridings@data$HDWin[ridings@data$FEDNUM==FN]<-HDWinner$party[HDWinner$FEDNUM==FN]
}
ridings@data$HDWin <- factor(ridings@data$HDWin)

for (FN in conWinner$FEDNUM) {
    ridings@data$conWin[ridings@data$FEDNUM==FN]<-conWinner$party[conWinner$FEDNUM==FN]
}
ridings@data$conWin <- factor(ridings@data$conWin)

for (FN in sentWinner$FEDNUM) {
    ridings@data$sentWin[ridings@data$FEDNUM==FN]<-sentWinner$party[sentWinner$FEDNUM==FN]
}
ridings@data$sentWin <- factor(ridings@data$sentWin,levels=c("Con","Lib","NDP","TIE"))


factpal <- colorFactor(c("royalblue1","red","orange","grey"), factor(c("Con","Lib","NDP","TIE")))
#b2<-paste(b1[1],b1[2],b1[3],sep="\n")

getWinMethod <- function(choice) {
   if (choice == 1) {
        return(ridings@data$fWin)
    }
    else if (choice ==2) {
        return(ridings@data$conWin)
    }
    else if (choice ==3) {
        return(ridings@data$HDWin)    
    }
    
    else {
        return(ridings@data$sentWin)
    }
}

Win<-getWinMethod(1)

getRidingNodesAndLinks <- function(theSelected,theMin) {
   theLinks<-tempLink[tempLink$riding==theSelected & tempLink$follower %in% Nodes$name[Nodes$size >= (theMin+1.718283)],]
   theNodes<-Nodes[Nodes$name %in% unique(theLinks$name),]
   theNodes<-rbind(theNodes,Nodes[Nodes$name %in% unique(theLinks$follower),])

   row.names(theLinks)<-NULL
   row.names(theNodes)<-NULL
   theNodes$theRow<-0
   for (i in 1:nrow(theNodes)) {
       theNodes$theRow[i]<-i-1
   }
   theLinks<-merge(theLinks,theNodes)
   theLinks$target<-theLinks$theRow
   theLinks<-theLinks[,1:8]
   theLinks<-merge(theLinks,theNodes,by.x="follower",by.y="name")
   theLinks$source<-theLinks$theRow
   theLinks<-theLinks[,6:8]

   tempSize<-aggregate(source~target,data=theLinks,FUN="length")

   for (i in 1:nrow(tempSize)) {
       theNodes$size[i]<-tempSize$source[i]
   }
   returnNodesAndLists<-list(theNodes,theLinks)
   return(returnNodesAndLists)
}


NodesLinks<-getRidingNodesAndLinks("Nepean",3.718283)

getText <- function(theSelected,exHash,exTwit,minF,maxW) {
    theText<-""
    if (theSelected==1) {
        theText <- toText
    }
    else {
        theText <- fromText        
    }
    
    theReturn<-termFreq(theText)
    theReturn<-theReturn[!grepl("^'",names(theReturn))]
    names(theReturn)<-gsub("'","",names(theReturn))
    if (exHash==TRUE){
        theReturn<-theReturn[!grepl("^#",names(theReturn))]        
    }
    if (exTwit==TRUE){
        theReturn<-theReturn[!grepl("^@",names(theReturn))]        
    }
    return(theReturn)
}
terms<-getText(1,FALSE,TRUE,20,100)