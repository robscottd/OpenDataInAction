
fluidPage(

    tags$style(type="text/css",
               "#mymap.recalculating { opacity: 1.0; }"),

        #    tags$style(type="text/css", ".recalculating { opacity: 1.0; }"),
    
          title="Bikes and Weather!",
          leafletOutput("mymap"),
          hr(),
          fluidRow(
              column(3,
                     selectInput("aWeather", "Choose Weather Factor:", 
                                 choices = list("Minimum Temperature"="minT",
                                                "Maximum Temperature"="maxT",
                                                "Total Precipitation"="totP"))),
              column(8,offset=1,
                     sliderInput("dates", "Dates", min=as.Date("2010-01-01", format="%Y-%m-%d"),
                                 max=as.Date("2015-09-30", format="%Y-%m-%d"),
                                 value=as.Date("2013-06-01", format="%Y-%m-%d"),width="80%",
                                 animate = animationOptions(interval = 500),
                                 dragRange = TRUE),
                     h4("Play Animation"),
                     p("Select start date on slider and click arrow below slider to the right to begin")
              )
          )
)