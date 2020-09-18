#
# Part of trench project (Grasshoppers)
# author Aji John https://github.com/ajijohn
# adapted from Shiny 
# Server
#


rgb.palette <- colorRampPalette(c("red", "orange", "blue"), space = "rgb")

df <- read.csv("rangeshift.csv")

# Do house  keeping
dat = read.csv("Ex3_rangedata.csv")

regions = c("AFSC_Aleutians" = "Aleutians", 
            "AFSC_EBS" = "Eastern Bering Sea", 
            "AFSC_GOA" = "Gulf of Alaska", 
            "DFO_Newfoundland_Fall" = "Newfoundland", 
            "DFO_ScotianShelf" = "Scotian Shelf", 
            "DFO_SoGulf" = "SoGulf(?)",        
            "NEFSC_Spring" = "Spring(?)",
            "SEFSC_GOMex" = "Gulf of Mexico",
            "WestCoast_Tri" = "West coast(?)"
            )

# Define server logic to do filtering
shinyServer(function(input, output) {
  
  # dataset <- reactive({       Need to change this to new dataset
  #  
  #   #restrict taxa
  #   dat %>% filter(TaxaGroup %in% input$taxa.sel)
  #   
  #   #restrict margin
  #   dat %>% filter(Margin %in% input$margins.sel)
  #   })
  #
  
  output$organisms <- renderUI({
    if (input$taxa == "Fish") {
      pickerInput("fish", "Select fish", choices = c("All", "Skates" = "skates", "Eels" = "eels", "Sharks" = "sharks"))
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
  
  # output$RangeShift <- renderPlot({
  #     
  #   latPlot <- ggplot(data = df_filter(), aes(x = obslat1, y = gamhlat1)) +
  #     geom_point() + 
  #     xlab("Thermal envelope shift (°N/yr)") + ylab("Taxon shift (°N/yr)") +
  #     theme_bw(base_size = 16) + geom_abline(intercept=0, slope=1, col='red') + xlim(min(df$obslat1), max(df$obslat1)) + ylim(min(df$obslat1), max(df$obslat1))
  #   
  #   depthPlot <- ggplot(data = df_filter(), aes(x = obsdepth1, y = gamhdepth1)) +
  #     geom_point() + 
  #     xlab("Thermal envelope shift (m/yr)") + ylab("Taxon shift (m/yr)") +
  #     theme_bw(base_size = 16) + geom_abline(intercept=0, slope=1, col='red') + xlim(min(df$obsdepth1), max(df$obsdepth1)) + ylim(min(df$obsdepth1), max(df$obsdepth1))
  #   
  #   grid.arrange(latPlot, depthPlot, ncol=2)
  # })
  
  output$regionInput <- renderUI({
    choices = unname(regions[unique(df_filter()[,"region"])])
    
    selectInput("region", "Regions", choices = c("All", choices))
  })
  
  # Still working on it
  # df_refilter <- reactive({
  #   validate(
  #     need(input$region, "")
  #   )
  #   if(input$region != "All") {
  #     filter(df_filter(), regions[which(input$region %in% regions)])
  #   } else {
  #     df_filter()
  #   }
  # })
  
  output$Rangeshift <- renderPlotly({
    if (input$switch == "Latitude") {
      fig <- plot_ly() %>%
        add_trace(data = df_filter(), x = ~ obslat1, y = ~ gamhlat1, name = "Data points", type = "scatter", mode = "markers") %>%
        add_trace(x = c(min(df$obslat1), max(df$obslat1)), y = c(min(df$obslat1), max(df$obslat1)), name = "1:1 line", type = "scatter", mode = "lines") %>%
        layout(xaxis = list(title = "Thermal envelope shift (°N/yr)"),
               yaxis = list(title = "Taxon shift (°N/yr)"))
    } else {
      fig <- plot_ly() %>%
        add_trace(data = df_filter(), x = ~ obsdepth1, y = ~ gamhdepth1, name = "Data points", type = "scatter") %>%
        add_trace(x = c(min(df$obsdepth1), max(df$obsdepth1)), y = c(min(df$obsdepth1), max(df$obsdepth1)), name = "1:1 line", type = "scatter", mode = "lines") %>%
        layout(xaxis = list(title = "Thermal envelope shift (m/yr)"),
               yaxis = list(title = "Taxon shift (m/yr)"))
    }
    fig
  })
  
  
})
