# Scratch

library(dplyr)
library(tidyr)
library(streamgraph)
library(lubridate)
library(lazyeval)
library(DT)
library(rebird)


MyEBirdData %>% 
	mutate(Date = mdy(Date)) %>% 
	separate(Date, into = c("Year", "Month", "Day"), remove = FALSE)%>%
	mutate(CalendarDay = mdy(paste(Month, Day, "2016",  sep = "-")), Monthly = mdy(paste(Month, "1", "2016"))) %>% 
	group_by(Common.Name, Monthly) %>% 
	tally()%>% 
	streamgraph(key = Common.Name, value = n, date = Monthly) %>% 
	sg_axis_x(1, "month", "%b")




MyEBirdData %>% 
	leaflet() %>% 
	addProviderTiles("CartoDB.Positron") %>% 
	addMarkers()


a <- MyEBirdData %>% group_by(Submission.ID, Latitude, Longitude) %>% 
	nest()


SpeciesList <- function(data){
	list <- data %>% unnest() %>% select(Common.Name) %>% datatable()
	list
}

a %>% 
	leaflet() %>% 
	addProviderTiles("CartoDB.Positron") %>% 
	setView(lng = 0, lat = 0, zoom = 1)




addCircleMarkers(stroke = FALSE, 
		 fillOpacity = 0.1, 
		 color = "#226666", 
		 radius = 5) 



test <- a[1,] %>% select(data) %>% unnest()

test1 <- SpeciesList(a[1,])
test1

MyEBirdData %>% group_by(Submission.ID, Latitude, Longitude) %>% tally() %>% 
	
	submissionSpCount(MyEBirdData) %>% 
	leaflet() %>% 
	addProviderTiles("CartoDB.Positron") %>% 
	setView(lng = 0, lat = 0, zoom = 1) %>% 
	addCircleMarkers(stroke = FALSE, 
			 fillOpacity = 0.4, 
			 color = "#226666", 
			 radius = ~n) 
# Data to map--
# number of species per 'Submission'

submissionSpCount <- function(data){
	data %>% group_by(Submission.ID, Latitude, Longitude) %>% tally()
}


# Stats data- more general things

lifeList <- function(data){ # life list-- # of species seeen
	data %>% group_by(Common.Name) %>% tally()
}

lifeList(MyEBirdData) %>% datatable(rownames = FALSE, filter = "top")


MyEBirdData %>% 
	mutate(Date = mdy(Date)) %>% 
	separate(Date, into = c("Year", "Month", "Day"), remove = FALSE) %>%
	mutate(CalendarDay = mdy(paste(Month, Day, "2016",  sep = "-")), Monthly = mdy(paste(Month, "1", "2016")), 
	       Weekly = week(Date)) %>%  
	group_by_("Common.Name", 'Weekly') %>% 
	tally()

# Try to speed up the ebirdgeo funtion with JSONlite
lf <- lifeList(MyEBirdData)

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


a <- ebirdNeedList(lifelist = lf, lat = 42.46, lon = -76.51)

geoList <- function(lat, lon){
	# Build the url for the JSON call.
	base <- "http://ebird.org/ws1.1/data/obs/geo/recent"
	lat <- paste('&lat=', lat, sep = '')
	lng <- paste('?lng=', lon, sep = '')
	url <- paste(base, lng, lat, "&dist=50&back=30&maxResults=10000&locale=en_US&fmt=json", sep = '')
	# Pull JSON from ebird
	allSpps <- fromJSON(url) # need to test if allSpps returns a length of 0. Then what...
	if (length(allSpps) == 0){ 
		allSpps <- NULL
	} 
	
	allSpps
}


b <- geoList(lat = 42.46, lon = -76.51)


