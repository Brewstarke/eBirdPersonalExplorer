
# This is the server logic for a Shiny web application.
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

lifeList <- function(data){ # life list-- # of species seeen  @^* Can be used as a filter for mapping where selected birds were seen.
	data %>% group_by(Common.Name) %>% tally()
} 


shinyServer(function(input, output) {

	
	# create dataframe from loaded data for use in app 
	# Move this to an intro tab page with instructions:
	eBird_filedata <- reactive({
		req(input$ebirdData)
		infile <- input$ebirdData
		data <- read.csv(infile$datapath, header = TRUE)
		data 
	})
	
		output$speciesDT <- DT::renderDataTable({
			lifeList(eBird_filedata()) %>% 
				datatable(rownames = FALSE, filter = "top")
		    })
	

	
	# Map 1 ----
	# Points of all observations across globe.
	# Use same methods as superzip- make blank map then use leafletProxy to add data.

		output$eBirdMap <- renderLeaflet({
			req(input$ebirdData)
			leaflet() %>% 
			addProviderTiles("CartoDB.Positron") %>% 
				setView(lng = 5, lat = 5, zoom = 2)
		})
		
		# Hopefully this fixes the points not loading on the map on tab #2
		outputOptions(output, 'eBirdMap', priority = 1)
	
	observe({
		leafletProxy('eBirdMap') %>% 
			clearShapes() %>% 
			addCircleMarkers(data = eBird_filedata(), 
					 lng = ~Longitude, 
					 lat = ~Latitude,
					 stroke = FALSE, 
					 fillOpacity = .8, 
					 color = "#226666", 
					 radius = 3, 
					 popup = ~Common.Name,
					 layerId = ~Submission.ID)
		
	})
	
	# Display list of common names from each submission on click of map. Nearly all this borrowed form SuperZip app.
	# showSpeciesListPopup <- function(listID, lat, lon){
	# 	selectedSubmission <- mapData()[mapdata()$Submission.ID == listID,]
	# 	content <- as.character()
	# }
	# 
	# clickList <- reactive(
	# 	click <- input$ebirdMap_marker_click
	# )
	# 
	# output$speciesList <- renderDataTable(
	# 	if(is.null(input$ebirdData)){
	# 		return(NULL)
	# 	}
	# 	
	# 	SpeciesList <- function(input$ebirdMap_marker_click){
	# 		list <- data %>% unnest() %>% select(Common.Name) %>% datatable()
	# 		list
	# 	}
	# )
	
	
})
