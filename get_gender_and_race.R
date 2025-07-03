
# load packages 
require(dplyr)
require(tidycensus)

# libary(emspackage)
# pull_data(2023, 'populations')

# Create empty data frame for storing later
gender_data <- data.frame()

# User Selections
most_recent_year <- 2023 # select the most recent year
starting_year <- 2009
state <- "55" # Wisconsin state fips code
cache_table <- "TRUE" # save some memory and time
geography <- "county" # location we want the data
moe <- 90 # acceptable numeric margin of error 
acsx <- "acs5" # select version and year of acs data
output <- "tidy" # format of data output

# all the gender data we need
for (i in most_recent_year[[1]]:starting_year[[1]]){
  tmp <- get_acs(
    geography = geography,
    variables = c(# Males
                  "B01001A_002", 
                  "B01001B_002", 
                  "B01001C_002", 
                  "B01001D_002",
                  "B01001E_002", 
                  "B01001F_002", 
                  "B01001G_002", 
                  "B01001I_002", 
                  "B01001H_002",
                  
                  # Females
                  "B01001A_017", 
                  "B01001B_017", 
                  "B01001C_017", 
                  "B01001D_017",
                  "B01001E_017", 
                  "B01001F_017", 
                  "B01001G_017", 
                  "B01001I_017",
                  "B01001H_017"
    ),
    year = i, 
    state = state,
    cache_table = cache_table
  ) %>%
    mutate(race = 
             case_when(
               # Males
               variable == "B01001A_002" ~ "White Alone",
               variable == "B01001B_002" ~ "Black or African American Alone",
               variable == "B01001C_002" ~ "American Indian and Alaskan Native Alone",
               variable == "B01001D_002" ~ "Asian Alone",
               variable == "B01001E_002" ~ "Native Hawaiian and Other Pacific Islander Alone",
               variable == "B01001F_002" ~ "Some Other Race Alone",
               variable == "B01001G_002" ~ "Two or More Races",
               variable == "B01001I_002" ~ "Hispanic or Latino",
               variable == "B01001H_002" ~ "White Alone, Not Hispanic or Latino",

               # Females
               variable == "B01001A_017" ~ "White Alone",
               variable == "B01001B_017" ~ "Black or African American Alone",
               variable == "B01001C_017" ~ "American Indian and Alaskan Native Alone",
               variable == "B01001D_017" ~ "Asian Alone",
               variable == "B01001E_017" ~ "Native Hawaiian and Other Pacific Islander Alone",
               variable == "B01001F_017" ~ "Some Other Race Alone",
               variable == "B01001G_017" ~ "Two or More Races",
               variable == "B01001I_017" ~ "Hispanic or Latino",
               variable == "B01001H_017" ~ "White Alone, Not Hispanic or Latino",

               .default = as.character(variable)
               ),
           gender = 
             case_when(
               # Males
               variable == "B01001A_002" ~ "Male",
               variable == "B01001B_002" ~ "Male",
               variable == "B01001C_002" ~ "Male",
               variable == "B01001D_002" ~ "Male",
               variable == "B01001E_002" ~ "Male",
               variable == "B01001F_002" ~ "Male",
               variable == "B01001G_002" ~ "Male",
               variable == "B01001I_002" ~ "Male",
               variable == "B01001H_002" ~ "Male",

               # Female
               variable == "B01001A_017" ~ "Female",
               variable == "B01001B_017" ~ "Female",
               variable == "B01001C_017" ~ "Female",
               variable == "B01001D_017" ~ "Female",
               variable == "B01001E_017" ~ "Female",
               variable == "B01001F_017" ~ "Female",
               variable == "B01001G_017" ~ "Female",
               variable == "B01001I_017" ~ "Female",
               variable == "B01001H_017" ~ "Female",

               .default = as.character(variable)
             ),
           year = i
           )
  gender_data <- rbind(gender_data, tmp)
}


