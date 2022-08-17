#install.packages("tidyverse")
library(tidyverse)
library(lubridate)
library(hms)
library(data.table)
#install.packages("janitor)
library(janitor)

#Load data from the .csv files (july 2021 - june 2022)


jul21_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202107-divvy-tripdata.csv")
aug21_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202108-divvy-tripdata.csv")
sep21_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202109-divvy-tripdata.csv")
oct21_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202110-divvy-tripdata.csv")
nov21_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202111-divvy-tripdata.csv")
dec21_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202112-divvy-tripdata.csv")
jan22_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202201-divvy-tripdata.csv")
feb22_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202202-divvy-tripdata.csv")
mar22_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202203-divvy-tripdata.csv")
apr22_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202204-divvy-tripdata.csv")
may22_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202205-divvy-tripdata.csv")
jun22_df <- read_csv("C:/Users/ebrah/OneDrive/Desktop/Data Analytics/Google Data Course/cycbike/202206-divvy-tripdata.csv")

#Merging all data frames

bikerides_df <- rbind(jul21_df,aug21_df,sep21_df,oct21_df,nov21_df,dec21_df,jan22_df,feb22_df,mar22_df,apr22_df,may22_df,jun22_df)

#Deleting the monthly data now that they have been merged to bikerides_df

remove(jul21_df,aug21_df,sep21_df,oct21_df,nov21_df,dec21_df,jan22_df,feb22_df,mar22_df,apr22_df,may22_df,jun22_df)

#Creating a new data frame to hold new columns required for analysis

bikeridesperiod_df <- bikerides_df

#Cleaning the data

  #Removing rows with NA values
bikeridesperiod_df <- na.omit(bikeridesperiod_df)

  #Removing duplicate records
bikeridesperiod_df <- distinct(bikeridesperiod_df)


#Determining the ride_length (ended_at - started_at, in minutes)

bikeridesperiod_df$ride_length <- difftime(bikeridesperiod_df$ended_at, bikeridesperiod_df$started_at, units = "mins")

  #Rounding to 2 decimal place
bikeridesperiod_df$ride_length <-round(bikeridesperiod_df$ride_length, digits = 2)

#Creating columns for year, month, day_of_week, day, time, hour

bikeridesperiod_df$date <- as.Date(bikeridesperiod_df$started_at)

  #Calculating the day_of_week
bikeridesperiod_df$day_of_week <- wday(bikeridesperiod_df$started_at)

  #Creating column for day_of_week
bikeridesperiod_df$day_of_week <- format(as.Date(bikeridesperiod_df$date), "%A")

  #Creating column for month
bikeridesperiod_df$month <- format(as.Date(bikeridesperiod_df$date), "%m")

  #Creating a column with the full month name
bikeridesperiod_df <- bikeridesperiod_df %>% mutate(months =
                                                      case_when(month == "01" ~ "January",
                                                                month == "02" ~ "February",
                                                                month == "03" ~ "March",
                                                                month == "04" ~ "April",
                                                                month == "05" ~ "May",
                                                                month == "06" ~ "June",
                                                                month == "07" ~ "July",
                                                                month == "08" ~ "August",
                                                                month == "09" ~ "September",
                                                                month == "10" ~ "October",
                                                                month == "11" ~ "November",
                                                                month == "12" ~ "December",
                                                                )
                                                    )


  #Creating column for day
bikeridesperiod_df$day <- format(as.Date(bikeridesperiod_df$date), "%d")

  #Creating column for year
bikeridesperiod_df$year <- format(as.Date(bikeridesperiod_df$date), "%Y")

  #Formatting time as HH:MM:SS
bikeridesperiod_df$time <- as_hms((bikeridesperiod_df$started_at))


  #Creating column for time
bikeridesperiod_df$time <- format(as.Date(bikeridesperiod_df$date), "%H:%M:%S")

  #Creating column for hour
  # bikeridesperiod_df$hour <- hour((bikeridesperiod_df$time), "HH")
  
  # bikeridesperiod_df$hour <- format(as.Date(bikeridesperiod_df$date), "%H")
  
  # bikeridesperiod_df$hour <- strptime(bikeridesperiod_df$time, "%H")

bikeridesperiod_df$hour <- hour(bikeridesperiod_df$time)

  #Creating column for seasons - summer, fall, winter, spring
bikeridesperiod_df <- bikeridesperiod_df %>% mutate(season =
                                                      case_when(month == "07" ~ "Summer",
                                                                month == "08" ~ "Summer",
                                                                month == "09" ~ "Fall",
                                                                month == "10" ~ "Fall",
                                                                month == "11" ~ "Fall",
                                                                month == "12" ~ "Winter",
                                                                month == "01" ~ "Winter",
                                                                month == "02" ~ "Winter",
                                                                month == "03" ~ "Spring",
                                                                month == "04" ~ "Spring",
                                                                month == "05" ~ "Spring",
                                                                month == "06" ~ "Summer")
)

#Cleaning the data a bit more 
  
  #Removing records where ride_length is zero or less than zero
bikeridesperiod_df <- bikeridesperiod_df[!(bikeridesperiod_df$ride_length <=0),]

  #Removing columns not required for analysis
bikeridesperiod_df <- bikeridesperiod_df %>%
  select(-c(ride_id,start_station_id,end_station_id,start_lat,start_lng,end_lat,end_lng))


#Viewing the data

View(bikeridesperiod_df)

#=========Total Number of Rides==========

nrow(bikeridesperiod_df)

#=========Status of Riders=========

bikeridesperiod_df %>%
  group_by(member_casual) %>%
  count(member_casual)

#=========Count by the Number of rideable_type=========

  #Number of rides per rideable_type
bikeridesperiod_df %>%
  group_by(rideable_type) %>%
  count(rideable_type)
  
  #Number of rides per rideable_type, categorized by member_casual
bikeridesperiod_df %>%
  group_by(member_casual, rideable_type) %>%
  count(rideable_type)

#=========Number of rides per Month=========

  #Number of Rides per month
bikeridesperiod_df %>%
  count(month)

  #Number of rides per month, grouped by member_casual
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  count(month) %>%
  print(n = 24)
  
#=========Number of rides per day of month=========

  #Number of rides per day of month
bikeridesperiod_df %>%
  count(day) %>%
  print(n = 31)

  #Number of rides per day of month grouped by member_casual
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  count(day) %>%
  print(n = 62)

#=========Number of rides per week=========

  #Number of rides per week
bikeridesperiod_df %>%
  count(day_of_week)

  #Number of rides per week grouped by member_casual
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  count(day_of_week)

#=========Number of rides per Hour=========

  #Number of rides per hour
bikeridesperiod_df %>%
  count(hour) %>%
  print(n = 24)

  #Number of rides per Hour grouped by member_casual
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  count(hour) %>%
  print(n = 48)

#=========Number of rides per season=========

  #Number of rides per season
bikeridesperiod_df %>%
  count(season) 

  #Number of rides per season grouped by member_casual
bikeridesperiod_df %>%
  group_by(season, member_casual) %>%
  count(season)

  #Summer rides
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  filter(season == "Summer") %>%
  count(season)

  #Fall rides
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  filter(season == "Fall") %>%
  count(season)

  #Winter
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  filter(season == "Winter") %>%
  count(season)

  #Spring
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  filter(season == "Spring") %>%
  count(season)


#=========Average length of rides=========

  #Average length of rides
bikerides_avglength <- mean(bikeridesperiod_df$ride_length)
print(bikerides_avglength)  

  #Average length per member_casual
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  summarise_at(vars(ride_length),
              list(time = mean))

  #Average length per rideable_type
bikeridesperiod_df %>%
  group_by(rideable_type) %>%
  summarise_at(vars(ride_length),
               list(time = mean))
  
  #Average length grouped by member-casual, rideable_type
bikeridesperiod_df %>%
  group_by(member_casual, rideable_type) %>%
  summarise_at(vars(ride_length),
               list(time = mean))

  #Average length of rides per hour
bikeridesperiod_df %>%
  group_by(hour) %>%
  summarise_at(vars(ride_length),
               list(time = mean)) %>%
  print(n = 24)

  #Average length per hour group by member_casual
bikeridesperiod_df %>%
  group_by(hour, member_casual) %>%
  summarise_at(vars(ride_length),
               list(time = mean)) %>%
  print(n = 48)

  #Average length per day of week
bikeridesperiod_df %>%
  group_by(day_of_week) %>%
  summarise_at(vars(ride_length),
               list(time = mean))

  #Average length per dayof week grouped by member_casual
bikeridesperiod_df %>%
  group_by(day_of_week, member_casual) %>%
  summarise_at(vars(ride_length),
               list(time = mean))

  #Average length per month
bikeridesperiod_df %>%
  group_by(month) %>%
  summarise_at(vars(ride_length),
               list(time = mean))

  #Average length per month grouped by member_casual
bikeridesperiod_df %>%
  group_by(month, member_casual) %>%
  summarise_at(vars(ride_length),
               list(time = mean)) %>%
  print(n = 24)

  #Average length per day of month
bikeridesperiod_df %>%
  group_by(day) %>%
  summarise_at(vars(ride_length),
               list(time = mean)) %>%
  print(n=31)

  #Average length per day of month grouped by member_casual
bikeridesperiod_df %>%
  group_by(day, member_casual) %>%
  summarise_at(vars(ride_length),
               list(time = mean)) %>%
  print(n = 62)

  #Average length of rides per season
bikeridesperiod_df %>%
  group_by(season) %>%
  summarise_at(vars(ride_length),
               list(time = mean))

  #Average length per season grouped by member_casual
bikeridesperiod_df %>%
  group_by(season, member_casual) %>%
  summarise_at(vars(ride_length),
               list(time = mean))

  #Average length of rides in the summer
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  filter(season == "Summer") %>%
  summarise_at(vars(ride_length),
               list(time = mean))

  #Average length of rides in the fall
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  filter(season == "Fall") %>%
  summarise_at(vars(ride_length),
               list(time = mean))

  #Average length of rides in winter
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  filter(season == "Winter") %>%
  summarise_at(vars(ride_length),
               list(time = mean))

  #Average length of rides in Spring
bikeridesperiod_df %>%
  group_by(member_casual) %>%
  filter(season == "Spring") %>%
  summarise_at(vars(ride_length),
               list(time = mean))

#Modifying columns in preparation for visualization

bikeridesperiod_df$ride_length <-round(bikeridesperiod_df$ride_length, digits = 2)


#Creating a new data frame for visualization

bikerides_viz <- bikeridesperiod_df

#Remove columns that are not required for visualization
bikerides_viz <- bikerides_viz %>%
  select(-c(started_at, ended_at, date, month,time))

#Viewing new data frame
View(bikerides_viz)

#Downloading the new data as a .csv file
fwrite(bikerides_viz,"cyclistic_bikerides.csv")
