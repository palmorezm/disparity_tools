
# Data we need: 
# Population totals (by county preferred)

# Gathering population data from each county over time 


# API key
census_api_key("afc5cb6a204acc0021390161be24a3b933a2c4ea", install = TRUE)
# year <- 2022 # input year of data 

# Global Factors
key <- NULL # hidden but shows API key 
# for security, this key should be loaded in each session
# year <- 2022 # input year of data 
acsx <- "acs5" # Select version and year of acs data
output <- "tidy" # format of data output
state <- 55 # FIPS code location of interest
zcta <- NULL # tabulate by zip code tabulation areas
moe <- 90 # acceptable num+eric margin of error 
geography <- "county" # location specific data
show_call <- FALSE # if TRUE, display call made to Census API
cache_table <- TRUE # whether or not to cache table names for faster future access. Defaults to FALSE



get_acs(
  geography = geography, 
  variables = c("B01001A_001", "B01001B_001", "B01001C_001"),
  year = year, 
  state = state,
  cache_table = cache_table
) %>%
  mutate(race = 
           case_when(
             variable == "B01001A_001" ~ "white",
             variable == "B01001B_001" ~ "black",
             variable == "B01001C_001" ~ "aian", 
             .default = as.character(variable)))


