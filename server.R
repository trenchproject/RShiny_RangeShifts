
df <- read.csv("rangeshift.csv")

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



shinyServer(function(input, output) {
  
  output$organisms <- renderUI({
    if (input$taxa == "Fish") {
      pickerInput("fish", "Select fish", choices = c("All", "Fish" = "fish", "Skates" = "skates", "Eels" = "eels", "Sharks" = "sharks"))
    } else if (input$taxa == "Crustaceans") {
      pickerInput("crustaceans", "Select crustaceans", choices = c("All", "Crabs" = "crabs", "Prawns" = "prawns", "Lobster" = "lobsters"))
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
        if(input$fish != "All") {
          filter(df, taxa %in% input$fish)
        } else {
          filter(df, taxa %in% c("fish", "skates", "eels", "sharks"))
        }
      } else if (input$taxa == "Crustaceans") {
        validate(
          need(input$crustaceans, "")
        )
        if (input$crustaceans == "All") {
          filter(df, taxa %in% c("crabs", "prawns", "lobsters"))
        } else {
          filter(df, taxa %in% input$crustaceans)
        }
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
  
  output$Rangeshift <- renderPlotly({
    validate(
      need(df_refilter(), "")
    )

    if (input$switch == "Latitude") {
      fig <- plot_ly() %>%
        add_trace(data = df_refilter(), 
                  x = ~ gamhlat1,  
                  y = ~ obslat1,
                  name = "Data points", 
                  type = "scatter", 
                  mode = "markers",
                  text = paste0(df_refilter()[,"name"], "<br>Taxa: ", R.utils::capitalize(df_refilter()[, "taxa"]), "<br>"),
                  hovertemplate = "%{text} (%{x:.2f}, %{y:.2f})") %>%
        add_trace(x = c(min(df$obslat1), max(df$obslat1)), 
                  y = c(min(df$obslat1), max(df$obslat1)), 
                  name = "1:1 line", 
                  type = "scatter", 
                  mode = "lines") %>%
        layout(xaxis = list(title = "Climate velocity (°N/yr)", range = c(-0.15, 0.15)),
               yaxis = list(title = "Observed population range shift (°N/yr)", range = c(-0.15, 0.3)))
    } else {
      fig <- plot_ly() %>%
        add_trace(data = df_refilter(), 
                  x = ~ gamhdepth1, 
                  y = ~ obsdepth1, 
                  name = "Data points", 
                  type = "scatter", 
                  mode = "markers",
                  text = paste0(df_refilter()[,"name"], "<br>Taxa: ", R.utils::capitalize(df_refilter()[, "taxa"]), "</br>"),
                  hovertemplate = "%{text} (%{x:.2f}, %{y:.2f})") %>%
        add_trace(x = c(min(df$obsdepth1), max(df$obsdepth1)), 
                  y = c(min(df$obsdepth1), max(df$obsdepth1)), 
                  name = "1:1 line", 
                  type = "scatter", 
                  mode = "lines") %>%
        layout(xaxis = list(title = "Climate velocity (m/yr)", range = c(-4, 8)),
               yaxis = list(title = "Observed population range shift (m/yr)", range = c(-8, 8)))
    }
  })
  
  
})
