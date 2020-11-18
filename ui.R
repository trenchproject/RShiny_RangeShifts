library(shiny)
#library(tidyverse)
#library(gridExtra)
library(plotly)
library(shinyWidgets)

#specify choices
taxa = c("All", "Fish", "Mollusks" = "mollusks", "Crustaceans", "Starfish/Brittle stars" = "starfish")

# Define UI 
shinyUI <- fluidPage(
  use_cicerone(),
  
  title = "Range shifts",

  includeMarkdown("include.md"),
  
  actionBttn(
    inputId = "tour",
    label = "Take a tour!", 
    style = "material-flat",
    color = "success",
    size = "sm"
  ),
  hr(),
 
  # Visualization of expected vs observed range shifts
  sidebarLayout(
    sidebarPanel(
      div(
        id = "sidebar-wrapper",
        pickerInput("taxa", "Select taxa", choices = taxa),
        uiOutput("organisms"),
        hr(),
        uiOutput("regionInput"),
        width = 3
      )
    ),
    
    mainPanel(
      div(
        id = "switch-wrapper",
        radioGroupButtons("switch", choices = c("Latitude", "Depth"), size = "sm", status = "warning")
      ),
      div(
        id = "plot-wrapper",
        plotlyOutput("Rangeshift"),
        width = 9
      )
    )
  ),
  
  hr()

)
