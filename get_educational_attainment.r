
# load packages 
require(dplyr)
require(tidycensus)

# Create empty data frame for storing later
educational_attainment_data <- data.frame()

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

# Table IDs for the below
# B15002B_003
# B15002B_004
# B15002B_005
# B15002B_006
# B15002B_007
# B15002B_008
# B15002B_009
# B15002B_010

            # Male
                # Less than 9th grade
                # 9th to 12th grade, no diploma
                # Regular high school diploma
                # GED or alternative credential
                # Some college, no degree
                # Associate's degree
                # Bachelor's degree
                # Graduate or professional degree

# Table IDs for female same edu things
# B15002B_012
# B15002B_013
# B15002B_014
# B15002B_015
# B15002B_016
# B15002B_017
# B15002B_018
# B15002B_019

                # Housing Costs as a Percentage of Household Income in the Past 12 Months (Hispanic or Latino Householder)
                # - B25140I	
                #  American Community Survey, ACS 1-Year Estimates Detailed Tables, 
                # Table B25140I, 2023, https://data.census.gov/table/ACSDT1Y2023.B25140I?q=B25140I: 
                # Housing Costs as a Percentage of Household Income in the Past 12 Months 
                # (Hispanic or Latino Householder)&g=040XX00US55. Accessed on December 2, 2024.

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


