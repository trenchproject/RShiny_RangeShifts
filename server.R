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
  
  dataset <- reactive({
   
    #restrict taxa
    dat %>% filter(TaxaGroup %in% input$taxa.sel)
    
    #restrict margin
    dat %>% filter(Margin %in% input$margins.sel)
    })
  
  df_filter <- reactive({
    filter(df, taxa %in% input$taxa)
  })
  
  # output$RangeShiftPlot <- renderPlot({
  #   
  #   ggplot(data=dataset(), aes_string(x=input$x, y = input$y, color=input$color))+
  #     theme_bw()+
  #     geom_point() + geom_smooth(method="lm", se=FALSE) 
  #   #+scale_colour_gradientn(colours =rgb.palette(20))
  #   
  #   #  +ylab("Development Index")+
  #   #  xlab(xlab.title)+labs(color="Mean season gdds")+
  #   #  theme(legend.position = "bottom") + guides(alpha=FALSE)
  #   
  # })
  
  output$RangeShift <- renderPlot({
    latPlot <- ggplot(data = df, aes(x = obslat1, y = gamhlat1)) +
      geom_point() + 
      xlab("Thermal envelope shift (°N/yr)") + ylab("Taxon shift (°N/yr)") +
      theme_bw(base_size = 16) + geom_smooth(method = "lm", se=FALSE) 
    
    depthPlot <- ggplot(data = df, aes(x = obsdepth1, y = gamhdepth1)) +
      geom_point() + 
      xlab("Thermal envelope shift (°N/yr)") + ylab("Taxon shift (°N/yr)") +
      theme_bw(base_size = 16) + geom_smooth(method = "lm", se=FALSE)
    
    grid.arrange(latPlot, depthPlot, nrow=2)
  })
})
