# Global 
# define functions called in server.R

# COlor Palette:
palettonReds <- c('#AA3939','#FFAAAA', '#D46A6A', '#801515', '#550000')
palettonOranges <- c('#AA6C39', '#FFD1AA', '#D49A6A', '#804515', '#552700')
palettonBlues <- c('#226666', '#669999', '#407F7F', '#0D4D4D', '#003333')
palettonGreens <- c('#2D882D', '#88CC88', '#55AA55', '#116611', '#004400')
colorBrewPal <- c('#8e0152', '#c51b7d', '#de77ae', '#f1b6da', '#fde0ef', '#f7f7f7', '#e6f5d0', '#b8e186', '#7fbc41', '#4d9221', '#276419')
pal <- brewer.pal(11, name = 'Spectral')


palettonGrad <- function(shade){
	grad <- c(palettonReds[shade], palettonOranges[shade], palettonBlues[shade], palettonGreens[shade])
	grad
}

# Stats data- more general things
lifeList <- function(data){ # life list-- # of species seeen  @^* Can be used as a filter for mapping where selected birds were seen.
	data %>% group_by(Common.Name) %>% tally()
} 


# Data to map--
# number of species per 'Submission'

submissionSpCount <- function(data){
	data %>% group_by(Submission.ID, Latitude, Longitude) %>% tally()
}





eBirdSpeciesStream <- function(data){
	# Display your personal eBird data in a stream plot summarized across a 'typical' year.
	# Idea-- add a control mechanism to select the 'scale' of the summary (month or day or even year for big ebird datasets)
	# Issue with passing a variable of 'monthly', 'weekly' or 'daily' to streamgraph.
	# data is summarized down to the calendar day (Month and Day of all years)
	data %>% 
		mutate(Date = mdy(Date)) %>% 
		separate(Date, into = c("Year", "Month", "Day"), remove = FALSE) %>%
		mutate(CalendarDay = mdy(paste(Month, Day, "2016",  sep = "-")), Monthly = mdy(paste(Month, "1", "2016")), 
		       Weekly = week(Date)) %>%  # try to fix weekly
		group_by_("Common.Name", 'Monthly') %>% 
		tally()%>% 
		mutate(n = n) %>% 
		streamgraph(key = 'Common.Name', value = n, date = 'Monthly') %>% 
		sg_legend(show = TRUE, label = 'Species') %>% 
		sg_fill_manual(values = palettonOranges)
}


