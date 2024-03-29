library(slidify)
rm(list = ls())
setwd('../Desktop')
author('DDPapp',use_git=F,open_rmd=F)
file.create('.nojekyll')
foo <- file(paste0(getwd(),'/assets/layouts/twocol.html'))
writeLines("---
layout: slide
---
{{{ slide.content }}}
<div style='float:left;width:49%;'>
  {{{ slide.left.html }}}
</div>
<div style='float:right;width:51%;'>
  {{{ slide.right.html }}}
</div>",foo)
close(foo)
download.file('http://tinyurl.com/ob84rzm',destfile='./assets/img/logo.gif',mode='wb')
download.file('http://tinyurl.com/nolu7sd',destfile='./assets/img/biglogo.gif',mode='wb')
foo <- file('index.Rmd')
writeLines("---
title       : 'Danger Zone'
subtitle    : Crime Rates by US State
author      : MartinSRC
job         : Head Marketer of Danger Mouse Crime Apps
logo        : logo.gif
biglogo     : biglogo.gif
github:
  user: MartinSRC
  repo: DDPapp
framework   : io2012
highlighter : highlight.js
hitheme     : solarized_light
widgets     : [bootstrap, quiz, interactive]
ext_widgets : {rCharts: libraries/nvd3}
mode        : selfcontained
knit        : slidify::knit2slides
---  &twocol w1:60% w2:40% 
<style> aside.gdbar img {width: 80px; height: 80px; position: absolute;
	right: 0; margin: 10px 10px;}.title-slide {background-color: #ECFAFD;}
	slides > slide:not(.nobackground):after {content: ' ';} slide.smallcode pre {
  font-size: 12px; line-height: 1.5em;
} </style>
```{r options, echo=F, warning=F}
library(knitr)
opts_chunk$set(comment=NA, tidy=F, warning=F, message=F, fig.align='center',fig.width=3, fig.height=3)
```
## Big Problem (1/5)

*** =left
The United States suffers from: Crime.
> - Which states are safe and which should we avoid? 
> - We have data to exploit: [USArrests](http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/USArrests.html)
> - All we need do is analyse it

```{r sumfmary,results='asis'}
kable(head(USArrests),format='markdown')
```

*** =right
<img style='float: right' src='https://i.imgur.com/HKI0367.jpg' />

--- .smallcode &twocol

## Base Plots (2/5)
Are we going to do it the old fashion way with base R?

*** =left
```{r plotscode, eval=1}
summary(USArrests) #Boring!
```

```{r plotscode2, eval=F}
boxplot(USArrests) #Lame!
hist(USArrests$Murder) #Eww!
```
There's got to be a better way!?  
  
*Danger Mouse Crime Apps* presents...


*** =right
```{r plotsreal, echo=F, fig.width=5, fig.height=7}
par(mfrow=c(2,1),mar=c(3,2,1,2))
boxplot(USArrests)
hist(USArrests$Murder)
```

---

## Danger Zone! (3/5)
<iframe frameborder='0' src='https://martinsrc.shinyapps.io/DDPapp/'></iframe>

---

## Features (4/5)
- Loess Smoother Trend Modelling? Got it!
- State Name Display for easy reading? You bet!
- Complete X and Y Variable manipulation? Oorah!
- Heat colour functionality that works on names? Hot!
- Automated cut'n'label of variables for facets? Divisive!
- Support using all features simultaneously? Orchestral!

    **Danger Mouse Crime Apps:** *Because there's always and app for that.*

--- .smallcode &twocol

## Code (5/5) 
*** =left
**server.R**
```{r nhjhk, eval=F}
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
```

*** =right
**ui.R**
```{r nhjhjhk, eval=F}
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

```

Invest, and fight crime with data analysis.

",foo)
close(foo)
slidify('index.Rmd')
shell('rename "index.md" "README.md"')
shell('index.html')