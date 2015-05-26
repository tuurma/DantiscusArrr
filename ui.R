library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Dantiscus demo"),
  
  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", h4("Choose a dataset:"), 
                  choices = c("Dantiscus all", "from Dantiscus", "to Dantiscus", "Latin", "German")),
    
    sliderInput("yr", label = h4("Year"), min = 1500, 
        max = 1548, value = c(1500, 1548)),

    sliderInput("rng", label = h4("Observations"), min = 1, 
        max = 6000, value = c(1, 50)),
        img(src='dantyszek.jpg', align = "left", width="300")

    
    ),
    
    
        # Show a tabset that includes a plot, summary, and table view
    # of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
        tabPanel("Data", tableOutput("view")),
        tabPanel("sub", tableOutput("view2")),
        tabPanel("Summary", verbatimTextOutput("summary")), 
        tabPanel("Plot", plotOutput("plot")), 
        tabPanel("Languages", plotOutput("langplot")), 
        tabPanel("Map all", leafletOutput("mapplot")), 
        tabPanel("Map", leafletOutput("map2")), 
        tabPanel("Archives", plotOutput("archiveplot")) 
       
      )
    )

  )
))
