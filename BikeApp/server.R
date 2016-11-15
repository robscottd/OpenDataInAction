function(input, output, session) {
    theDay <-  reactive({  
        getDay(input$aWeather,input$dates)
    })
    thePal <-  reactive({  
        getPal(input$aWeather)
    })
    thePalRange <-  reactive({  
        getPalRange(input$aWeather)
    })

    output$mymap <- renderLeaflet({
#        Sys.sleep(1)
#        invalidateLater(1000)
        day<-theDay()
        palW<-thePal()
        palRange<-thePalRange()
        popup<-paste(sep = "<br/>",
                     paste0("<b>",day$Location,"</b>"),
                     paste0("<b>","Count: ","</b>",day$theCount)
        )
    
            leaflet(day)%>% setView(lng = -75.698157, lat = 45.416841, zoom = 13) %>% addTiles() %>%
                addCircles(lng = ~lon, lat = ~lat, weight = 1,color="Black",fillColor = ~palW(theWeather),
                           radius = ~sqrt(theCount)*10, popup = ~Location
                ) %>%
                addLegend("bottomright", pal = palW,values=palRange$aRange,
                          title = palRange$aTitle,
                          opacity = 1
                )
    })
}