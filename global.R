# Global 
# define functions called in server.R



# Stats data- more general things
lifeList <- function(data){ # life list-- # of species seeen  @^* Can be used as a filter for mapping where selected birds were seen.
	data %>% group_by(Common.Name) %>% tally()
} 


# Data to map--
# number of species per 'Submission'

submissionSpCount <- function(data){
	data %>% group_by(Submission.ID, Latitude, Longitude) %>% tally()
}