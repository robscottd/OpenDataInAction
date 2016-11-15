
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

navbarPage("Ottawa 311 Noise Incidents",theme = shinytheme("flatly"),
           tabPanel("2015 Ward Map",                          
                    sidebarLayout(
                        sidebarPanel(            
                            radioButtons("radio1", label = "Time Period",
                                         choices = list("Current" = 1,
                                                        "1794" = 2),selected = 1),
                            sliderInput("Opa", "Ward Opacity", 0.1, 0.6, value=0.4),
                            div(p("To see ward name, number and its total noise incidents, click on the ward on the map."),
                                br(),
                                p("To zoom in and out on the map, place mouse over map and scroll down or up.  To
                      scroll web page, mouse must be off map."),style = "color:seagreen"),
                            width=3),
                    mainPanel(
                        leafletOutput("mymap"),
                        div(p("1794 map layer from The Lionel Pincus & Princess Firyal Map Division, The New York Public Library."))
                    )

                    )

           ),
           
           tabPanel("2015 Chart",                          
                    sidebarLayout(
                        sidebarPanel(            
                            radioButtons("radio2", label = h4("Ottawa Wards"),
                                         choices = list("All" = 1,
                                                        "Ward 12 Rideau-Vanier" = 2,
                                                        "Ward 14 Somerset" = 3),selected = 1),
                            div(p("Pick wards for chart")),
                            br(),
                            width=3),
                        mainPanel(
                            plotOutput("zoom", height = "350px"),
                            plotOutput("overall", height = "150px",
                                       brush =  brushOpts(id = "brush", direction = "x"))
                        )
                    )
           ),
           tabPanel("2016 Chart",
                        basicPage(
                            plotOutput("zoom2", height = "350px"),
                            plotOutput("overall2", height = "150px",
                                       brush =  brushOpts(id = "brush", direction = "x"))
                        )
                    )
)