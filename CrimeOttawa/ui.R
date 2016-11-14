navbarPage("Ottawa Crime Statistics",theme = shinytheme("flatly"),
 #       tabsetPanel(
         tabPanel("Choropleth Maps",                          
              sidebarLayout(
                 sidebarPanel(            
                     selectInput("yearSelect", "Choose a Year:", 
                                 choices = list("2005"="2005",
                                                "2006"="2006",
                                                "2007"="2007",
                                                "2008"="2008",
                                                "2009"="2009",
                                                "2010"="2010",
                                                "2011"="2011",
                                                "2012"="2012",
                                                "2013"="2013"),selected = "2013"),
                     selectInput("ccSelect", "Choose Crime Class:", 
                                 choices = list("Total"="total",
                                                "Crimes Against Person"="person",
                                                "Crimes Against Property"="prop",
                                                "Traffic Offences"="traffic",
                                                "Drug Offences"="drug",
                                                "Other Offences"="other")),
                     radioButtons("statSelect","Choose Statistic",
                                  c("Total"="total","Solvency%"="solv","Rate per 100,000 population"="rate"),selected="total"),
                    div(p("To see Ward Name and value for selected Year, Crime Class and Statistic,
                          click on the Ward on the map."),
                        br(),
                        p("To zoom in and out on the map, place mouse over map and scroll down or up.  To
                          scroll web page, mouse must be off map."),style = "color:seagreen"),
                    br(),
                    width=3),  
                 
    
                 mainPanel(
                    leafletOutput("mymap"),
                    h4("Welcome!"),
                    p("This app provides a choropleth (intensity) map for Ottawa 
                      Crime Statistics, grouped by City Wards."),
                    br(),
                    h3("Interested in joining the Open Data Institute? Send an email to ottawa@theodi.org !"),
                    br()
                    )
    )
)

)