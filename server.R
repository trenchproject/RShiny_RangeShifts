#
# Part of trench project (Grasshoppers)
# author Aji John https://github.com/ajijohn
# adapted from Shiny 
# Server
#

library(shiny)
library(cowplot)

#
rgb.palette <- colorRampPalette(c("red", "orange", "blue"), space = "rgb")

# Do house  keeping
dat=read.csv(paste(getwd(),"/Ex3_rangedata.csv",sep = ""))

# Define server logic to do filtering
shinyServer(function(input, output) {
  
  dataset <- reactive({
   
    #restrict taxa
    dat %>% filter(TaxaGroup %in% input$taxa.sel)
    
    #restrict margin
    dat %>% filter(Margin %in% input$margins.sel)
    })
  
  
  output$RangeShiftPlot <- renderPlot({
    
    ggplot(data=dataset(), aes_string(x=input$x, y = input$y, color=input$color))+
      theme_bw()+
      geom_point()+geom_smooth(method="lm",se=FALSE) 
    #+scale_colour_gradientn(colours =rgb.palette(20))
    
    #  +ylab("Development Index")+
    #  xlab(xlab.title)+labs(color="Mean season gdds")+
    #  theme(legend.position = "bottom") + guides(alpha=FALSE)
    
  })
  
})
