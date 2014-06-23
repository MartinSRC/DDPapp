
library(shiny)
library(ggplot2)
shinyServer(
  function(input, output) {
cuts <- c('Low','Middle','High')
z <- apply(USArrests, 2, cut, breaks=3,labels=cuts)
colnames(z) <- paste0('By',colnames(z))
arrests <- cbind(USArrests,z)
i <- 5
for(i in i:8) arrests[,i] <- factor(arrests[,i],levels=rev(cuts))
output$plot <- reactivePlot( function() {
  ggp <- ggplot(arrests,aes_string(x=input$x, y=input$y)) +
theme_bw() + geom_point() 
  facet <- paste0(input$facet,'~.')
if (input$colour != 'None')
 ggp <- ggp + aes_string(color=input$colour) + 
scale_colour_gradientn(colours=rev(heat.colors(2)))
if (facet != '.~.')
 ggp <- ggp + facet_grid(facet)
if (input$smooth)
 ggp <- ggp + geom_smooth()
if (input$statenames)
 ggp <- ggp + geom_text(aes(label=gsub(' ','',rownames(USArrests))))
print(ggp)
},
height=800)})

