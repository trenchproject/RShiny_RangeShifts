library(shiny)
library(tidyverse)
library(gridExtra)
library(plotly)
library(shinyWidgets)

#specify choices
taxa = c("All", "Fish", "Mollusks" = "mollusks", "Crustaceans", "Starfish" = "starfish", "Brittle stars" = "brittle")
# Define UI 
shinyUI <- fluidPage(  
  title = "Range shifts",

  includeMarkdown("include.md"),
  
  hr(),
 
  # Visualization of expected vs observed range shifts
  sidebarLayout(
    sidebarPanel(
      pickerInput("taxa", "Select taxa", choices = taxa),
      uiOutput("organisms"),
      hr(),
      uiOutput("regionInput"),
      width=3
    ),
    
    mainPanel(
      radioGroupButtons("switch", choices = c("Latitude", "Depth"), size = "sm", status = "warning"),
      plotlyOutput("Rangeshift"),
      width=9
    )
  ),

  
  hr()

)
