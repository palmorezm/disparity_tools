
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
               # This was started but did not finish 
               variable == "B01001A_002" ~ "Less than 9th grade - White Alone",
               variable == "B01001B_002" ~ "9th to 12th grade, no diploma - White Alone", 
               #  and onwards... 
               variable == "B01001C_002" ~ "American Indian and Alaskan Native Alone",
               variable == "B01001D_002" ~ "Asian Alone",
               variable == "B01001E_002" ~ "Native Hawaiian and Other Pacific Islander Alone",
               variable == "B01001F_002" ~ "Some Other Race Alone",
               variable == "B01001G_002" ~ "Two or More Races",
               variable == "B01001I_002" ~ "Hispanic or Latino",
               variable == "B01001H_002" ~ "White Alone, Not Hispanic or Latino",

# TODO: Add these with each racial/ethnic group
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

          # TODO: Add this one with each racial/ethnic group
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

# TODO: Addtional table to get based on ID:
# "MEDIAN AGE BY SEX (WHITE ALONE)"
# But for each race/ethnic group and Male & Female
# White alone example:
  # B01002_001 (Total)
  # B01002A_002 (Male)
  # B01002A_003 (Female)
# Black alone example:
  # B01002_001 (Total)
  # B01002B_002 (Male)
  # B01002B_003 (Female)


# TODO next:
# Turn these scripts into a function. 
# Name this function something descriptive
# Ex: GET_Race_Ethnicity()
# Inputs should be:
  # common language text selections
  # followed by a numerical or text data type representing the year or years (for now) 
# Ex: I = ( ... , c('Population', 'Median Age', 2023)) 
# Default inputs should be (unless otherwise specified by user)
  # 'Population' , specifically total population for each race/ethnic goup
  # Most recent year 
    # Feel free to use = current_year_char <- format(Sys.Date(), "%Y") or similar
    # May need to adjust for a year or two earlier given what's availble from census 
# Ex: O = data.frame of values with each value
  # split by each race/ethnic group and
  # sex (as applicable)
  # estimate (the actual number they think it is)
  # moe or Margin of error (as available)
  # variable - these are the corresponding table IDs
  # County name
  # GEOID unique code

# Once we have this we can build on it
# Start to do math and later make forecasts/predictions
# It might be interesting to show 
# how quickly diversity is happening in each county and across the state

