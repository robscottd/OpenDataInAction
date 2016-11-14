function(input, output, session) {
Winner <-  reactive({  
      getWinMethod(input$radio)
  })
theNodesLinks <-  reactive({  
    getRidingNodesAndLinks(input$riding,input$minFol)
})

terms <- reactive({
#    withProgress({getText(input$radioWords,input$xHash,input$xTwit,input$minFreq,input$maxWords)},message = 'Generating data')
    getText(input$radioWords,input$xHash,input$xTwit,input$minFreq,input$maxWords)
})
    output$mymap <- renderLeaflet({
        Win<-Winner()
#        popup <- paste0("<strong>Riding: </strong>", 
#                        ridings@data$ENNAME,"\n",ridings@data$Con)

        popup<-paste(sep = "<br/>",
                     paste0("<b>",gsub("--","-",ridings@data$ENNAME),"</b>"),
                     paste0("Con: ",ridings@data$Con),
                     paste0("Lib: ",ridings@data$Lib),
                     paste0("NDP: ",ridings@data$NDP)
        )
        
        
        leaflet(ridings)  %>% setView(lng = -75.686389, lat = 45.226389, zoom = 9) %>%
            addTiles() %>%
            addPolygons(weight=2,fillOpacity = 0.4, smoothFactor = 0.5,color="black",  
                        fillColor = ~factpal(Win),popup=popup)%>%
    addLegend("bottomright", pal = factpal, values = ~Win,
                      title = "Parties",
                      opacity = 1
            )
    })
    output$force <- renderForceNetwork({
        withProgress({NodesLinks<-theNodesLinks()
        ridingNodes<-NodesLinks[[1]]
        ridingLinks<-NodesLinks[[2]]
        forceNetwork(Links = ridingLinks, Nodes = ridingNodes,
                     Source = "source", Target = "target",
                     Value = "value", NodeID = "name",Nodesize="size",Group = "group",
                     colourScale = JS("d3.scale.ordinal().domain(['Con', 'Lib', 'NDP','follower']).range(['royalblue', 'red', 'darkorange','green'])"),
                     fontSize = 12,radiusCalculation = JS("Math.sqrt(d.nodesize) + 2"), 
                     charge=-20,opacity = 0.4,zoom=TRUE,legend=TRUE)},message="Generating Graph")
    })
    output$plot <- renderPlot({
        withProgress({wordcloud(names(terms()), terms(), scale=c(3.5,0.3),
                  min.freq = input$minFreq, max.words=input$maxWords,
                  colors=brewer.pal(8, "Dark2"))},message="Generating Cloud")
})

}