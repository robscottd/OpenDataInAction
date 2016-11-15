
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
function(input, output) {
    
#        theP <-  reactive({  
#            getP(input$radio2)
#        })
    
    output$mymap <- renderLeaflet({
        
        popup<-paste(sep = "<br/>",
                     paste0("<b>",wardPoly@data$DESCRIPTIO,"</b>"),
                     paste0("Ward Number: ",wardPoly@data$WARD_NUM),
                     paste0("Total Incidents: ",wardPoly@data$noiseCount)
        )
        if(input$radio1==1) {
            leaflet(wardPoly)  %>% setView(lng = -75.67724, lat = 45.29814, zoom = 10) %>%
                addTiles() %>%
                addPolygons(weight=2,fillOpacity = input$Opa, smoothFactor = 0.5,color="black",  
                            fillColor = ~factpal(noiseCount),popup=popup)%>%
                addLegend("bottomright", pal = factpal, values = ~noiseCount,
                          title = "Incidents",
                          opacity = 1
                )            
        }
        else {
        leaflet(wardPoly)  %>% setView(lng = -75.67724, lat = 45.29814, zoom = 10) %>%
            addTiles() %>%
            addTiles("http://maps.nypl.org/warper/maps/tile/13864/{z}/{x}/{y}.png",
                     options = tileOptions(opacity = 0.5)) %>%
            addPolygons(weight=2,fillOpacity = input$Opa, smoothFactor = 0.5,color="black",  
                        fillColor = ~factpal(noiseCount),popup=popup)%>%
            addLegend("bottomright", pal = factpal, values = ~noiseCount,
                      title = "Incidents",
                      opacity = 1
            )}
    })
    
#    p <- ggplot(barMelt12, aes(as.Date(charDate), value)) + geom_line(aes(colour = variable))

#    p <- theP[[input$radio2]] + xlab("Date") + ylab("Noise Incidents") + ggtitle("Ottawa 311 Noise Incidents")

   output$zoom <- renderPlot({
       p <- theP[[as.integer(input$radio2)]] + xlab("Date") + ylab("Noise Incidents") + ggtitle("Ottawa 311 Noise Incidents-Select Dates to Zoom") + ylim(0,thePMax[as.integer(input$radio2)])
       if (!is.null(input$brush)) {
            p <- p + xlim(as.Date(c(input$brush$xmin,input$brush$xmax),origin="1970-01-01"))
        }
        p
    })

    output$overall <- renderPlot({
        p1<-theP[[as.integer(input$radio2)]] + xlab("Date") + ylab("Noise Incidents") + ggtitle("Select Date Range to Zoom in on Above Chart")
        p1
    })
        
    
    p2 <- ggplot(barMelt2016, aes(as.Date(theDay), value)) + geom_line(aes(colour = TYPE))
    p2 <- p2 + xlab("Date") + ylab("Noise Incidents") + ggtitle("Ottawa 311 Noise Incidents")
    output$zoom2 <- renderPlot({
        if (!is.null(input$brush)) {
            p2 <- p2 + xlim(as.Date(c(input$brush$xmin,input$brush$xmax),origin="1970-01-01"))
        }
        p2
    })
    output$overall2 <- renderPlot(p2)
    
}
