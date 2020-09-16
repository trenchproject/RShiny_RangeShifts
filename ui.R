#Range shifts
#

library(shiny)
library(tidyverse)
library(gridExtra)

#specify choices
taxa= c("aquatic","insects","birds","mammals")
margins = c("Upper","Lower","Average")

dataset <- read.csv("Ex3_rangedata.csv")

# Define UI 
shinyUI <- fluidPage(  
  title = "Range shifts",

  includeMarkdown("include.md"),
  hr(),
  # Place the filter horizontally
 #  fluidRow(
 #     column(4,selectInput('x', 'Predictor variable (X)', c('Number of Species'='Nspecies','Duration (Years)'='Duration_Years',	'Mean Observed Shift (km)'='ObservedShift_km',	'SE Observed Shift (km)'='SEObservedShift_km',	'Expected Shift (km)'='ExpectedShift_km',	'Temperature Change (C)'='TemperatureChange_C')), selected='ObservedShift_km'),
 #     column(4,selectInput('y', 'Response variable (y)', c('Number of Species'='Nspecies','Duration (Years)'='Duration_Years',	'Mean Observed Shift (km)'='ObservedShift_km',	'SE Observed Shift (km)'='SEObservedShift_km',	'Expected Shift (km)'='ExpectedShift_km',	'Temperature Change (C)'='TemperatureChange_C')), selected='ExpectedShift_km'),
 #     column(4,selectInput('color', 'Color coding', c('Number of Species'='Nspecies','Duration (Years)'='Duration_Years',	'Mean Observed Shift (km)'='ObservedShift_km',	'SE Observed Shift (km)'='SEObservedShift_km',	'Expected Shift (km)'='ExpectedShift_km',	'Temperature Change (C)'='TemperatureChange_C')))
 #  ),
 # 
 # #pick species and sites 
 #  fluidRow(
 #    column(4,selectInput('taxa.sel', 'Select taxa to plot', choices= as.character(taxa), multiple=TRUE, selectize=FALSE, selected=taxa)),
 #    column(4,selectInput('margins.sel', 'Select range margins to plot', choices= as.character(margins), multiple=TRUE, selectize=FALSE, selected=margins))
 #  ),
 
  # Show a plot of the generated distribution
  # plotOutput(outputId="RangeShiftPlot", width="800px",height="600px"),
  sidebarLayout(
    sidebarPanel(
      selectInput("taxa", "Select taxa", choices = c("All", "fish"))
    ),
    mainPanel(
      plotOutput("RangeShift")
    )
  ),

  
  hr(),
  
  includeMarkdown("include2.md"),
  
  hr()

)
