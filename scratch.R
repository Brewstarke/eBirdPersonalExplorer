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




# Idea-- add a control mechanism to select the 'scale' of the summary (month or day or even year for big ebird datasets)
eBirdSpeciesStream <- function(data){
	# Display your personal eBird data in a stream plot summarized across a 'typical' year.
	# data is summarized down to the calendar day (Month and Day of all years)
	data %>% 
		mutate(Date = mdy(Date)) %>% 
		separate(Date, into = c("Year", "Month", "Day"), remove = FALSE) %>%
		mutate(CalendarDay = mdy(paste(Month, Day, "2016",  sep = "-")), Monthly = mdy(paste(Month, "1", "2016")), 
		       Weekly = week(Date)) %>%  
		group_by_("Common.Name", 'Weekly') %>% 
		tally()%>% 
		streamgraph(key = 'Common.Name', value = 'n', date = 'Weekly') 
}
	
eBirdSpeciesStream(MyEBirdData)
