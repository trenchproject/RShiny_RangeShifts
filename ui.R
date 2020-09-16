#Range shifts
#

library(shiny)
library(tidyverse)
library(gridExtra)

#specify choices
taxa= c("All","Fish","Mammals","Invertebrates")

# Define UI 
shinyUI <- fluidPage(  
  title = "Range shifts",

  includeMarkdown("include.md"),
  
  hr(),
 
  # Visualization of expected vs observed range shifts
  sidebarLayout(
    sidebarPanel(
      selectInput("taxa", "Select taxa", choices = taxa),
      width=3
    ),
    mainPanel(
      plotOutput("RangeShift"),
      width=9
    )
  ),

  hr(),
  
  includeMarkdown("include2.md"),
  
  hr()

)
