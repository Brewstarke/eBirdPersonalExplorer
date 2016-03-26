
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


shinyServer(function(input, output) {

	
	# create dataframe from loaded data for use in app 
	# Move this to an intro tab page with instructions:
	eBird_filedata <- reactive({
		req(input$ebirdData)
		infile <- input$ebirdData
		data <- read.csv(infile$datapath, header = TRUE)
		data 
	})
	output$fileuploaded <- reactive({
		return(is.null(input$ebirdData))
	})
	outputOptions(output, 'fileuploaded', suspendWhenHidden = FALSE)
	
	output$dataready <- reactive({
		return(!is.null(input$ebirdData))
	})
	outputOptions(output, 'dataready', suspendWhenHidden = FALSE)
		
	eBird_lifelist <- reactive({
		lf <- lifeList(eBird_filedata())
		lf
	})
	
		output$speciesDT <- DT::renderDataTable({
			lifeList(eBird_filedata()) %>% select(Common.Name) %>% 
				datatable(rownames = FALSE, filter = "top", extensions = 'Scroller', options = list(scroller = TRUE, scrollY = 600, pageLength = 100))
		    })
		
		output$latlon <- renderText(unlist(input$eBirdMap_click[1:2]))
		
		
		
		ebirdNeedList <- function(lifelist, lat, lon){
			
			# Build the url for the JSON call.
			base <- "http://ebird.org/ws1.1/data/obs/geo/recent"
			lat <- paste('&lat=', lat, sep = '')
			lng <- paste('?lng=', lon, sep = '')
			url <- paste(base, lng, lat, "&dist=50&back=30&maxResults=10000&locale=en_US&fmt=json", sep = '')
			# Pull JSON from ebird
			allSpps <- fromJSON(url) # need to test if allSpps returns a length of 0. Then what...
			
			# make list of species recorded in eBird life list
			allSpps %<>% rename(Common.Name = comName) %>% anti_join(lifelist)
			
			if (length(allSpps) == 0){ 
				allSpps <- NULL
			} 
			
			allSpps
			
		}
		
		
		
	sppsNeeds <- reactive({
		req(input$eBirdMap_click)
		spps <- ebirdNeedList(lifelist = eBird_lifelist(),lat = as.numeric(input$eBirdMap_click[1]), lon = as.numeric(input$eBirdMap_click[2]))
		spps
	})
	
	output$spNeeds <- renderDataTable({
		sppsNeeds() %>% select(Common.Name) %>% datatable(rownames = FALSE, 
								  filter = "top", 
								  extensions = 'Scroller', 
								  options = list(scroller = TRUE, scrollY = 400, pageLength = 1000))
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
	
		sppsNeedPopup <- function(comName, Date){
			info <- paste(sep = "<br/>", h4(comName), Date)
			info
		}
		
	observe({
		if(!is.null(sppsNeeds())){ # test if sppsNeeds is NULL- should add return 'popup' or similar to notofy user
		leafletProxy('eBirdMap') %>% 
			clearShapes() %>% 
			addCircleMarkers(data = sppsNeeds(), 
					 stroke = FALSE,
					 fillOpacity = 0.6,
					 color = "#214C7E",
					 radius = 4,
					 popup = ~paste(sep = "<br/>", Common.Name, obsDt), 
					 clusterOptions = markerClusterOptions(showCoverageOnHover = FALSE, spiderfyOnMaxZoom = FALSE, zoomToBoundsOnClick = TRUE))
				
		}
		})
	observe({
		# if(!is.null(sppsNeeds())){ # test if sppsNeeds is NULL- should add return 'popup' or similar to notofy user
			leafletProxy('eBirdMap') %>% 
				clearShapes() %>% 
				addCircleMarkers(data = eBird_filedata(), 
						 lng = ~Longitude,
						 lat = ~Latitude,
						 stroke = FALSE,
						 fillOpacity = .8,
						 color = "#072953",
						 radius = 3,
						 popup = ~Common.Name,
						 layerId = ~Submission.ID)
	})
	
	
	output$spStreamPlot <-  renderStreamgraph({
		eBirdSpeciesStream(eBird_filedata())
		})
	
	
})
