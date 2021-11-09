library(dplyr)
library(viridis)

source("cicerone.R", local = T)

df <- read.csv("rangeshift.csv")

df[df$taxa == "brittle", "taxa"] <- "starfish"

df <- df %>% mutate(taxa2 = taxa)

for(i in 1:nrow(df)) {
  if (is.null(df[i,"taxa"]) || is.na(df[i,"taxa"])){
    df[i,"taxa2"] <- ""
  }else if (df[i,"taxa"] == "flatfish" || df[i,"taxa"] == "skates" || df[i,"taxa"] == "eels" || df[i,"taxa"] == "sharks") {
    df[i,"taxa2"] <- "fish"
  } else if (df[i,"taxa"] == "crabs" || df[i,"taxa"] == "prawns" || df[i,"taxa"] == "lobster") {
    df[i,"taxa2"] <- "crustaceans"
  } else if (df[i,"taxa"] == "squids" || df[i,"taxa"] == "clams" || df[i,"taxa"] == "sea snails") {
    df[i,"taxa2"] <- "mollusks"
  }
}


regions = c("AFSC_Aleutians" = "Aleutians", 
            "AFSC_EBS" = "Eastern Bering Sea", 
            "AFSC_GOA" = "Gulf of Alaska", 
            "DFO_Newfoundland_Fall" = "Newfoundland", 
            "DFO_ScotianShelf" = "Scotian Shelf", 
            "DFO_SoGulf" = "Gulf of St Lawrence",        
            "NEFSC_Spring" = "US East coast",
            "SEFSC_GOMex" = "Gulf of Mexico",
            "WestCoast_Tri" = "US West coast"
)


shinyServer <- function(input, output) {
  
  observeEvent(input$tour, guide$init()$start())
  
  observeEvent(input$reset, {
    reset("page")
  })
  
  output$organisms <- renderUI({
    if (input$taxa == "Fish") {
      pickerInput("fish", "Select fish", 
                  choices = c("Flatfish" = "flatfish", "Skates" = "skates", "Eels" = "eels", "Sharks" = "sharks", "Others" = "fish"), 
                  multiple = TRUE, 
                  selected = c("flatfish", "skates", "eels", "sharks", "fish"))
    } else if (input$taxa == "Crustaceans") {
      pickerInput("crustaceans", "Select crustaceans", 
                  choices = c("Crabs" = "crabs", "Prawns" = "prawns", "Lobster" = "lobsters"), 
                  multiple = TRUE, 
                  selected = c("crabs", "prawns", "lobsters"))
    } else if (input$taxa == "Mollusks") {
      pickerInput("mollusks", "Select mollusks", 
                  choices = c("Squids" = "squids", "Clams" = "clams", "Sea snails" = "sea snails"),
                  multiple = TRUE,
                  selected = c("squids", "clams", "sea snails"))
    }
  })
  
  
  df_filter <- reactive({
    if (input$taxa == "All") {
      df
    } else {
      if (input$taxa == "Fish") {
        validate(
          need(input$fish, "")
        )
        filter(df, taxa %in% input$fish)
        
      } else if (input$taxa == "Crustaceans") {
        validate(
          need(input$crustaceans, "")
        )
        filter(df, taxa %in% input$crustaceans)
        
      } else if (input$taxa == "Mollusks") {
        validate(
          need(input$mollusks, "")
        )
        filter(df, taxa %in% input$mollusks)
      } else {
        filter(df, taxa %in% input$taxa)
      }
    }
  })
  
  
  output$regionInput <- renderUI({
    choices = unname(regions[unique(df_filter()[,"region"])])
    
    selectInput("region", "Regions", choices = c("All", choices))
  })
  
  df_refilter <- reactive({
    validate(
      need(input$region, "")
    )
    if(input$region != "All") {
      filter(df_filter(), region %in% names(regions)[which(regions %in% input$region)])
    } else {
      df_filter()
    }
  })
  
  viridis <- c(viridis_pal(option = "D")(5)[[1]], viridis_pal(option = "D")(5)[[2]],viridis_pal(option = "D")(5)[[3]],viridis_pal(option = "D")(5)[[4]],viridis_pal(option = "D")(5)[[5]])
  
  output$Rangeshift <- renderPlotly({
    validate(
      need(df_refilter(), "")
    )
    
    if (input$switch == "Latitude") {
      if(input$taxa == "All"){
        fig <- plot_ly() %>%
          add_trace(data = df_refilter(), 
                    x = ~ gamhlat1,  
                    y = ~ obslat1,
                    color = ~ taxa2,
                    colors = viridis,
                    type = "scatter", 
                    mode = "markers",
                    text = paste0(df_refilter()[,"name"], "<br>Taxa: ", R.utils::capitalize(df_refilter()[, "taxa2"]), "<br>"),
                    hovertemplate = "%{text} (%{x:.2f}, %{y:.2f})") %>%
          add_trace(x = c(min(df$obslat1), max(df$obslat1)), 
                    y = c(min(df$obslat1), max(df$obslat1)), 
                    name = "1:1 line", 
                    type = "scatter", 
                    mode = "lines") %>%
          layout(xaxis = list(title = "Climate velocity (°N/yr)", range = c(-0.1, 0.15)),
                 yaxis = list(title = "Observed population range shift (°N/yr)", range = c(-0.15, 0.3)))
      } else {
        fig <- plot_ly() %>%
          add_trace(data = df_refilter(), 
                    x = ~ gamhlat1,  
                    y = ~ obslat1,
                    color = ~ taxa,
                    colors = viridis,
                    type = "scatter", 
                    mode = "markers",
                    text = paste0(df_refilter()[,"name"], "<br>Taxa: ", R.utils::capitalize(df_refilter()[, "taxa2"]), "<br>"),
                    hovertemplate = "%{text} (%{x:.2f}, %{y:.2f})") %>%
          add_trace(x = c(min(df$obslat1), max(df$obslat1)), 
                    y = c(min(df$obslat1), max(df$obslat1)), 
                    name = "1:1 line", 
                    type = "scatter", 
                    mode = "lines") %>%
          layout(xaxis = list(title = "Climate velocity (°N/yr)", range = c(-0.1, 0.15)),
                 yaxis = list(title = "Observed population range shift (°N/yr)", range = c(-0.15, 0.3)))
      }
    } else {
      fig <- plot_ly() %>%
        add_trace(data = df_refilter(), 
                  x = ~ gamhdepth1, 
                  y = ~ obsdepth1, 
                  color = ~ taxa2,
                  colors = viridis,
                  type = "scatter", 
                  mode = "markers",
                  text = paste0(df_refilter()[,"name"], "<br>Taxa: ", R.utils::capitalize(df_refilter()[, "taxa2"]), "</br>"),
                  hovertemplate = "%{text} (%{x:.2f}, %{y:.2f})") %>%
        add_trace(x = c(min(df$obsdepth1), max(df$obsdepth1)), 
                  y = c(min(df$obsdepth1), max(df$obsdepth1)), 
                  name = "1:1 line", 
                  type = "scatter", 
                  mode = "lines") %>%
        layout(xaxis = list(title = "Climate velocity (m/yr)", range = c(-4, 7)),
               yaxis = list(title = "Observed population range shift (m/yr)", range = c(-8, 8)))
    }
  })
  
}
