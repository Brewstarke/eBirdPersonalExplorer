
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


shinyUI(navbarPage("eBird Personal Observations Explorer", 
	tabPanel("Observation Mapper",
	 leafletOutput(outputId = "eBirdMap", width = '100%', height = 800),
	# Sidebar with a slider input for number of bins 
		absolutePanel(id = "controls", fixed = TRUE,
		      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
		      width = 250, height = "auto",
		      h3('Load in you eBird data:'),
		      fileInput("ebirdData",
		      	  "Select your eBird data file:",
		      	  width = 250),
			DT::dataTableOutput('speciesDT'))
			), 
	# Data Loading and Intro to the app:
	tabPanel("Personal eBird Explorer",
		 fluidPage(
		 	fluidRow(
		 		column(12,
		 		       h3("eBird Data Explorer"),
		 		       p('Looking for a snapshot of your "birding" life? Load in your eBird personal data and lets begin')),
		 		column(12,
		 		        streamgraph::streamgraphOutput('spStreamPlot'))
		 		)
		 
		 )
	)
))


