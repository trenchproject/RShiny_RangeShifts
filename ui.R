library(shiny)
library(plotly)
library(shinyWidgets)
library(cicerone)
library(markdown)
library(shinyjs)
library(shinyBS)

#specify choices
taxa = c("All", "Fish", "Mollusks", "Crustaceans", "Starfish/Brittle stars" = "starfish")

# Define UI 
shinyUI <- fluidPage(id = "page",
  use_cicerone(),
  setBackgroundColor(color = "#C7DAE0"),
  useShinyjs(),
  
  title = "Range shifts",
  
  includeMarkdown("include.md"),
  
  actionBttn(
    inputId = "reset",
    label = "Reset", 
    style = "material-flat",
    color = "danger",
    size = "xs"
  ),
  bsTooltip("reset", "If you have already changed the variables, reset them to default here before starting the tour."),
  
  actionBttn(
    inputId = "tour",
    label = "Take a tour!", 
    style = "material-flat",
    color = "success",
    size = "sm"
  ),
  hr(),
 
  # Visualization of expected vs observed range shifts
  div(
    id = "viz-wrapper",
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
          radioGroupButtons("switch", choices = c("Latitude", "Depth"), selected = "Latitude", size = "sm", status = "warning")
        ),
        div(
          id = "plot-wrapper",
          plotlyOutput("Rangeshift"),
          width = 9
        )
      )
    )
  ),
  
  hr()

)
