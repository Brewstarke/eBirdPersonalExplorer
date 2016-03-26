
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(htmltools)
library(shinyapps)
library(streamgraph)
library(dplyr)
library(tidyr)
library(rebird)
library(magrittr)
library(leaflet)
library(rgdal)
library(dplyr)
library(tidyr)
library(readr)
library(DT)
library(shinythemes)

shinyUI(navbarPage("eBird Life List Explorer", theme = "bootstrapyeti.css",
	tabPanel("Observation Mapper",
	 leafletOutput(outputId = "eBirdMap", width = '100%', height = 800),
	# File load absolutePanel
	absolutePanel(id = "controls", fixed = TRUE,
		      draggable = FALSE, top = 60, left = '50%', bottom = '50%',
		      width = 300, height = "auto",
		      conditionalPanel(
		      	condition = "output.fileuploaded", 
		      	h3("Explore your submitted eBird Observations"),
		      	h5('Navigate to', a(href = 'http://ebird.org/ebird/downloadMyData', 'eBird'), 'to download your personal observations'),
			p('Follow the instructions by clicking the "submit" button'),
			p('Unzip the file link that is sent to your email account'),
			p('Take note of where you saved your data.'),
		      	fileInput("ebirdData",
		      		  "Click below to select your eBird data:",
		      		  width = 300))
			),
	absolutePanel(fixed = TRUE, style = 'opacity: 1', class = "panel panel-default",
		      draggable = TRUE, top = 60, right = 60,
		      width = 300, height = "auto",
		      conditionalPanel(
				condition = 'output.dataready',
				h5("And find where species you've missed have been recently seen"),
				p("click on the map in an area you're interested in and see which birds have recently been observed there that aren't on your life list"),
				dataTableOutput('spNeeds'))
		)
			), 
	# Data Loading and Intro to the app:
	tabPanel("Personal eBird Explorer",
		 fluidPage(
		 	fluidRow(
		 		column(12,
		 		       h3("eBird Data Explorer"),
		 		       p('Colorful view of your typical birding year...')),
		 		column(12,
		 		        streamgraph::streamgraphOutput('spStreamPlot')),
		 		column(3),
		 		column(6, 
		 		       h3("Life List"),
		 		       p("recorded in eBird database"),
		 		       dataTableOutput('speciesDT')),
		 		column(3)
		 		)
		 
		 )
	)
))


