#
# Part of trench project (Grasshoppers)
# author Aji John https://github.com/ajijohn
# adapted from Shiny 
# Server
#


rgb.palette <- colorRampPalette(c("red", "orange", "blue"), space = "rgb")
df <- read.csv("rangeshift.csv")
df$taxa <- NA
df$taxa[5] <- "fish"
df$taxa[6] <- "squid"

# Do house  keeping
dat = read.csv("Ex3_rangedata.csv")

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
  # df_filter <- reactive({
  #   filter(df, taxa %in% input$taxa)
  # })
  
  output$RangeShift <- renderPlot({
    latPlot <- ggplot(data = df, aes(x = obslat1, y = gamhlat1)) +
      geom_point() + 
      xlab("Thermal envelope shift (°N/yr)") + ylab("Taxon shift (°N/yr)") +
      theme_bw(base_size = 16) + geom_abline(intercept=0, slope=1, col='red') 
    
    depthPlot <- ggplot(data = df, aes(x = obsdepth1, y = gamhdepth1)) +
      geom_point() + 
      xlab("Thermal envelope shift (°N/yr)") + ylab("Taxon shift (°N/yr)") +
      theme_bw(base_size = 16) + geom_abline(intercept=0, slope=1, col='red')
    
    grid.arrange(latPlot, depthPlot, ncol=2)
  })
})
