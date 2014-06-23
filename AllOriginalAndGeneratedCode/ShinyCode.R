setwd('../Desktop')
unlink('localshiny',recursive = T)
dir.create('localshiny')
setwd('../Desktop/localshiny')

foo <- file('server.R')
writeLines("
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
",foo)
close(foo)


foo <- file('ui.R')
writeLines("
library(shiny)
dataset <- USArrests
shinyUI(pageWithSidebar(
 titlePanel('Danger Zone: Crime Rates by US State'),
 sidebarPanel(
   h3('Supporting Documentation'),
   helpText('This app shows a scatter plot of the US Crime Rates data set.'),
   helpText('To help you get started, the available widgets are:'),
		p('1. Add a Loess smooth line'),
		p('2. Replacing dots with US State names'),
		p('3. Changing variables on the X and Y axis'),
		p('4. Adding HEAT colours (i.e. red = more crime)'),
		p('5. Facetting the data into three groups'),
   checkboxInput('smooth', 'Add Loess Smoother'),
   checkboxInput('statenames', 'Add State Names'),
   selectInput('x','X-Axis Variable',names(dataset), names(dataset)[[3]]),
   selectInput('y','Y-Axis Variable',names(dataset), names(dataset)[[2]]),
   selectInput('colour', 'Add Colours', c('None', names(dataset))),
   selectInput('facet','Add Facet', c(None='.', paste0('By',names(dataset))))
		),
  mainPanel(plotOutput('plot'))
))
",foo)
close(foo)

library(shiny)
runApp()


library(shinyapps)
shinyapps::deployApp(account='martinsrc',appName='DDPapp')