
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

