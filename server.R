library(shiny)
library(datasets)
library(leaflet)
setwd("C:/tuurma/visu/rApp")
letters<-read.csv("data/letters.csv", header=TRUE)



# Define server logic required to summarize and view the selected
# dataset
shinyServer(function(input, output) {

#dataset[,"year"]>=input$yr[1] & dataset[,"year"]<=input$yr[2] ,
  
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "Dantiscus all" = letters[letters[,"year"]>=input$yr[1] & letters[,"year"]<=input$yr[2],],
           "from Dantiscus" = letters[letters[,"fid"]==1 & letters[,"year"]>=input$yr[1] & letters[,"year"]<=input$yr[2],],
           "to Dantiscus" = letters[letters[,"tid"]==1 & letters[,"year"]>=input$yr[1] & letters[,"year"]<=input$yr[2],],
           "Latin" = letters[letters[,"lang"]=="Latin" & letters[,"year"]>=input$yr[1] & letters[,"year"]<=input$yr[2],],
           "German" = letters[letters[,"lang"]=="German" & letters[,"year"]>=input$yr[1] & letters[,"year"]<=input$yr[2],],
           )
  })
  
  # Generate a plot of the dataset
  output$plot <- renderPlot({
    dataset <- datasetInput()
    counts <- table(dataset$year)
    barplot(counts, main=paste("Letters Distribution ", input$yr[1], " - ", input$yr[2]), xlab="Years", ylab="Number of letters")

  })
  # Generate a plot of the dataset
  output$langplot <- renderPlot({
    dataset <- datasetInput()
    counts <- table(dataset$lang, dataset$year)
    barplot(counts, main=paste("Letters Distribution ", input$yr[1], " - ", input$yr[2]), xlab="Years", ylab="Number of letters",
    col=c("darkblue", "lightblue", "green", "yellow","red", "darkgreen", "lightgreen", "purple", "violet"),
legend = rownames(counts))

  })
  # Generate archive plot of the dataset
  output$archiveplot <- renderPlot({
    dataset <- datasetInput()
    counts <- table(dataset$archive, dataset$year)
    barplot(counts, main=paste("Letters Distribution ", input$yr[1], " - ", input$yr[2]), xlab="Years", ylab="Number of letters",
    col=c("darkblue", "lightblue", "green", "yellow","red", "darkgreen", "lightgreen", "purple", "violet"),
    legend = rownames(counts))
  })
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })


  # Show the first "n" observations
  output$view <- renderTable({
    dataset<-datasetInput()
    dataset[input$rng[1]:input$rng[2], ]
    
  })
  
  output$view2 <- renderTable({

 mpoints<-datasetInput()
    mpoints<-subset(mpoints, select=c("flat", "flng", "fplace"))
colnames(mpoints)<-c("lat", "lng", "name")
    mpoints[input$rng[1]:input$rng[2], ]
 })
  
  
  output$mapplot <- renderLeaflet({
    colnames(geocodes)<-c("name", "lat", "lng")

points <- eventReactive(input$recalc, geocodes, ignoreNULL = FALSE)
  
    leaflet() %>%
      addProviderTiles("Stamen.TonerLite",
        options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(data = points())
  })
  
   output$map2 <- renderLeaflet({
    mpoints<-datasetInput()
    mpoints<-subset(mpoints, select=c("flat", "flng", "fplace"))
    mpoints<-mpoints[!is.na(mpoints[,"flat"]),]
    mpoints<-unique(mpoints)
colnames(mpoints)<-c("lat", "lng", "name")

    
points <- eventReactive(input$recalc, mpoints, ignoreNULL = FALSE)
  
    leaflet() %>%
      addProviderTiles("Stamen.TonerLite",
        options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(data = points())
  })
  
})
