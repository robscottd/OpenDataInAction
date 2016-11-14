navbarPage("Ottawa Federal Election Twitter Analysis 2015",theme = shinytheme("flatly"),
 #       tabsetPanel(
 tabPanel("Home",                      
          
          sidebarPanel(
              h3("Welcome!"),
              p("This app provides Twitter-based insights into the Ottawa ridings
                for the Canadian 2015 Federal Election.  The Conservative, Liberal, and NDP candidates 
                for the following ridings are covered:"),
              div(p("* Carleton"),
              p("* Kanata Carleton"),
              p("* Ottawa Centre"),
              p("* Ottawa South"),
              p("* Ottawa West-Nepean"),
              p("* Ottawa-Orleans"),
              p("* Ottawa-Vanier"),style = "color:seagreen"),
              h4("Final Data Tally:"),
              div(p("* Over 56,000 followers"),
              p("* Over 17,000 tweets"),style = "color:seagreen"),
              br(),
              strong("data last updated: Oct. 18 2015")
          ),
          mainPanel(
              div(h2("Election Day is Over!"),style = "color:seagreen"),
              h3("Why Look at Twitter?"),
              p("Twitter has become an important tool for election candidates to get their
                message out and communicate with their constituency.  Through mining candidate
                Twitter followers and tweets, we can explore the relationships between candidates
                and followers and use them to predict how parties will fare in each riding."), 
              h3("Get Started"),
              h4("Make Predictions"),
              p("To try and make election predictions using the Twitter analysis, click on the above ",
                em("Predictor"),
                " link.  There are four prediction methods available:"),
              p(strong("*   Number of Followers")),
              p(strong("*   Number of Retweets/Favourites")),
              p(strong("*   Number of Followers Plus")),
              p(strong("*   Overall Sentiment")),
              br(),
              h4("Visualize Candidate/Follower relationships"),
              p("Network graphs are a great way to visualize social network relationships.  
                To create network graphs of follower to candidate relationships, click on the above ",
                em("Network Graph"), "link."),
              br(), 
              h4("Create Word Clouds"),
              p("Word Clouds provide insight into what words are used most frequently in a book, in a series of news stories, any 
                collection of text, or in this case, a set of tweets.  The size of each word indicates its relative frequency when compared to
                other words in the cloud.  To create tweet word clouds, click on the above ",
                em("Word Cloud"), "link."),
              br(),
              br(),
              p(a("Terms of Service",target="_blank",href="tos.html"))
          )
 ),
         tabPanel("Predictor",                          
              sidebarLayout(
                 sidebarPanel(            
                    radioButtons("radio", label = h3("Predictor Method"),
                            choices = list("Number of Followers" = 1, "Number of Retweets/Favourites" = 2,
                                           "Number of Followers Plus" = 3,
                                           "Overall Sentiment" = 4),selected = 3),
                    br(),
                    br(),
                    div(p("To see riding name and its associated candidates, click on the riding on the map."),
                    br(),
                    br(),
                    p("To zoom in and out on the map, place mouse over map and scroll down or up.  To
                      scroll web page, mouse must be off map."),style = "color:seagreen"),
                    width=3),  
                 
    
                 mainPanel(
                    leafletOutput("mymap"),
                        p("",strong("Number of Followers:"), "A simple predictor based on the total number of followers of each candidate."),
                        p("",strong("Number of Retweets/Favourites:"), "A predictor based on the total number of favourites and retweets the candidates' tweets receive."),
                        p("",strong("Number of Followers Plus:"), "A predictor based on the total number of followers a candidate has who also
                                        follows at least one other candidate in the Ottawa region.  Followers who follow multiple candidates are: "),
                        p("   * More likely to be following for political not personal purposes."),
                        p("   * More likely to be politically active and plan to vote."),
                        p("   * Less likely to be a fake/bot account."),
                        p("",strong("Overall Sentiment:"), "In this context, sentiment measures the relative positive or negative nature
                                        of tweets sent to candidates.  The predictor is based on the total sentiment score for each candidates."),
                        br(),
                        p("The colour of the riding on the map indicates the predicted winner, ties are identified as grey.  Check with the
                            Legend in the bottom right corner if you are not familiar with the political party colours.
                            If you are not sure of the name of an Ottawa riding on the map or its candidates, click on the riding and the information will pop up."),
                        br(),
                        br(),
                        p(a("Terms of Service",target="_blank",href="tos.html"))
                    
                    )
    )
),
           tabPanel("Network Graph",                      
         
              sidebarLayout(
                 sidebarPanel(
                 
                    selectInput("riding", "Choose riding network:", 
                                choices = list("Carleton"="Carleton",
                                               "Kanata-Carleton"="Kanata-Carleton",
                                               "Nepean"="Nepean",
                                               "Ottawa Centre"="Ottawa Centre",
                                               "Ottawa South"="Ottawa South",
                                               "Ottawa West-Nepean"="Ottawa West-Nepean",
                                               "Ottawa-Orleans"="Ottawa-Orleans",
                                               "Ottawa-Vanier"="Ottawa-Vanier"),selected="Nepean"),
                    sliderInput("minFol","Minimum Candidates Followed", min = 1,  max = 20,  value = 2),
                    br(),
                    br(),
                    div(p("To see a candidate's name, mouseover the party's node."),
                    br(),
                    br(),
                    p("To zoom in and out on the graph, place mouse over map and scroll down or up.  To
                      scroll web page, mouse must be off graph."),style = "color:seagreen"),
                    width=3),  
             
                mainPanel(
                    forceNetworkOutput("force"),
                p("The graph is generated for the selected riding (Nepean is the default).
                Each circle (node) represents either a candidate or a follower.  The lines between nodes represent 
                candidate-follower relationships.  The size of a node is determined by the numbers of candidate-follower 
                relationships it is involved in.  The larger nodes are the candidate nodes.  By using the",
                      em("Minimum Candidates Followed"),
                      " slider, you can filter the followers by how many candidates they follow in the Ottawa ridings.  
                Followers that follow several candidates might be journalists, political bloggers, political action 
                groups, community leaders/activists or community organizations."),
                    br(),
                    p("The network graph is dynamically generated and will take a few moments to settle.  Within most browsers,
                you can scroll-wheel zoom in and out on the graph as well as drag the graph to recentre.  If you mouse over a node, the name of the candidate will pop-up
                for candidate nodes and a anonymized ID number for follower nodes.  Below is an example of a network graph:"),
                    img(src = "sampleNetwork.png"),
                    p("In the image below, stars highlight the candidate nodes: "),
                    img(src = "sampleNetworkC.png"),
                    p("In the next image, followers who follow all three candidates are circled while followers who follow 
                two of the three candidates are highlighted by rectangles.  The followers that only follow one candidate
                in the riding just have one relationship line but you might notice some of their nodes are larger than others.  
                This indicates that the follower does follow other candidates in the Ottawa area but not in the selected riding."),
                    img(src = "sampleNetworkM.png"),
                br(),
                br(),
                p(a("Terms of Service",target="_blank",href="tos.html"))
                )
              )
),
tabPanel("Word Cloud",                      
         
         sidebarLayout(
             sidebarPanel(
                 
                 radioButtons("radioWords", label = h4("Choose word source:"),
                              choices = list("Tweets sent to candidates" = 1, "Tweets sent by candidates" = 2), selected = 1),
                 h4("Word filters:"),
                 checkboxInput("xHash", "Exclude HashTags", value = FALSE),
                 checkboxInput("xTwit", "Exclude Twitter Addresses", value = TRUE),
                 sliderInput("minFreq","Minimum word frequency", min = 10,  max = 100,  value = 20),
                 sliderInput("maxWords",
                             "Maximum number of words",
                             min = 10,  max = 300,  value = 100),
                 br(),
                 div(p(em("Remember"),
                 ",The size of each word indicates its relative frequency when compared to
                 other words in the cloud."),style = "color:seagreen"),
                 width=3),  
             
             mainPanel(
                 plotOutput("plot"),
                 p("Word Clouds are a great way to visualize the topical content in tweets to and from candidates."),
                 p("There are several options available to you:"),
                 p("    * Choose either Tweets to Candidates or Tweets sent by Candidates."),
                 p("    * Include or exclude hashtags."),
                 p("    * Include or exclude twitter addresses."),
                 p("    * Set minimum word frequency."),
                 p("    * Set maximum words in word cloud."),
                 
                 p("By using the",
                   em("Minimum word frequency"),
                   " slider, you can filter words by a minimum frequency."),
                 p("By using the",
                   em("Maximum number of words"),
                   " slider, you can limit the number of words to show in the word cloud."),
                 br(),
                 br(),
                 p(a("Terms of Service",target="_blank",href="tos.html"))
             )
         )
),
tabPanel("About",                      
         
         sidebarPanel(
             h3("Stay In Touch"),
             p("To keep up-to-date on all data updates,new features and news, please follow:"),
             a("OttawaElect2015", target="_blank",
               href = "https://twitter.com/OttawaElect2015"),
             p("on Twitter.  If you have a question or comment about the app, drop a tweet to:"),
             a("OttawaElect2015", target="_blank",
               href = "https://twitter.com/OttawaElect2015"),
             br(),
             br(),
             p("Thanks"),
             br(),
             p("Rob Davidson")
             
             ),
         mainPanel(
             h3("Ottawa Federal Election Twitter Analysis 2015"),
             br(),
             h4("Version 0.7",em("Updated: 2015/09/29")),
             p("   * Fixed time zone for",strong("Home"),"tab for election day count"),
             br(),
             br(),
             h4("Version 0.6",em("Updated: 2015/09/14")),
             p("   * moved instructions from",strong("Home"),"tab to appropriate tab"),
             p("   * added",strong("Terms of Service")," to bottom of each page"),
             p("   * added progress bars to",strong("Network Graph"),"and",strong("Word Cloud"),"tabs"),
             p("   * fixed",strong("Word Cloud")," tab to properly remove stop words in english and french"),
             br(),
             br(),
             h4("Version 0.5",em("Updated: 2015/09/11")),
             p("   * added",strong("Word Cloud")," tab and functionality"),
             p("   * added",strong("About")," tab"),
             p("   * changed",strong("Intro")," tab to ",strong("Home")," tab"),
             p("   * added instructions for",strong("Word Cloud")," to",strong("Home")," tab"),
             br(),
             br(),
             br(),
             p("Built using RStudio Shiny."),
             p("Leverages the following R libraries: rgdal, shinythemes, leaflet, networkD3, tm and wordcloud."),
             p("Sentiment analysis leverages the syuzhet R library."),
             p("Maps sourced from",
             a("OpenStreetMap.",  target="_blank",
                 href = "http://openstreetmap.org/")),
             p("If you are interested in an introduction to Shiny and live examples, visit the ",
               a("Shiny homepage.",  target="_blank",
                 href = "http://www.rstudio.com/shiny")),
             br(),
             br(),
             p(a("Terms of Service",target="_blank",href="tos.html"))
             )
)
)