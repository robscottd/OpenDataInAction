function(input, output, session) {

aPoly <- reactive({
#    withProgress({getText(input$radioWords,input$xHash,input$xTwit,input$minFreq,input$maxWords)},message = 'Generating data')
   getPoly(input$yearSelect,input$ccSelect,input$statSelect)
})
    output$mymap <- renderLeaflet({
        withProgress(message = 'Map generation in progress',{
            thePoly<-aPoly()
         if (!is.null(thePoly)){
            popup<-paste(sep = "<br/>",
                         paste0("<b>Ward Name:</b> ",thePoly@data$ward_Name),
                         paste0("<b>Value:</b> ",thePoly@data$numAmt)
            )
            leaflet(thePoly)  %>% setView(lng = location[1], lat = location[2], zoom = 9) %>%
                addTiles() %>%
                addPolygons(weight=2,fillOpacity = 0.6, smoothFactor = 0.5,color="black",  
                        fillColor = ~factpal(numAmt),popup=popup)%>%
            addLegend("bottomright", pal = factpal, values = ~numAmt,
                      title = "Value",
                      opacity = 1
            )
            
        }
        else {
            leaflet(thePoly)  %>% setView(lng = location[1], lat = location[2], zoom = 9) %>%
                addTiles()
        }
        })
    })
}