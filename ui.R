library(shiny)

shinyUI(fluidPage(
  titlePanel("NetworkRx"),
  h4("A tool to simulate, diagnose, and prescribe"),
  br(),
  sidebarLayout(
    sidebarPanel(
    h4("Network values"),
    p("Instructions: Adjust the sliders to see the effect on the network (please be patient while the network loads)"),
    sliderInput("slider1", label = h5("Nodes"), min = 0, 
                             max = 50, value = 21),
    sliderInput("slider2", label = h5("Density"), min = 0, 
                max = 1, value = 0.3),
    sliderInput("slider3", label = h5("Mean degree"), min = 0, 
                max = 10, value = 3.5),
    sliderInput("slider4", label = h5("Proportion 'like-to-like' ties"), min = 0, 
                max = 1, value = .20),
    checkboxInput("box1", label = h5("Allow isolates"),value=FALSE),
    radioButtons("size", label = h4("Size nodes according to"),
                 choices = list("Nothing" = 1, "Degree centrality" = 2, "Betweenness centrality" = 3), 
                 selected = 1)
      ),
    
      mainPanel(
          tabsetPanel(type = "tabs",    
          tabPanel("Simulate and Diagnose", plotOutput("plot1"),
          hr(),
          sliderInput("result1", "Probability of policy change for this network", min=0, max=1, value=.75),
          sliderInput("result2", "Probability of evidence use in this network", min=0, max=1, value=.9)),
          
          tabPanel("Prescribe", 
          br(),
          br(),
          a("Find Interventions to change network size"),
          br(),
          a("You increased your network's density: Find interventions to change density"),
          br(),
          a("You increased your network's centralization: Find interventions to change centralization"),
          br(),
          a("Interventions to change homophily"))
          
           )
      
      )
  )))

  
