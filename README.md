# PROJECT BACKGROUND

Cyclistic is a fictional bike-share company in Chicago that in 2016 launched a bike-share program which features more than 5,800 bicycles and 600 docking stations. Cyclistic differentiates itself by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities and riders who can’t use a standard two-wheeled bike. The program has grown to a fleet of 5,824 bicycles that are geo-tracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.
Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments while offering flexible pricing plans: single-ride passes, full-day passes, and annual memberships. They categorized customers who purchase single-ride, or full-day passes are referred to as casual riders and customers who purchase annual memberships are Cyclistic members.
Stakeholders:
Cyclistic executive team
Lily Moreno, Director of Marketing at Cyclistic
Cyclistic Marketing Analytics team
Role: part of the data analytics team tasked with the overall goal of designing marketing strategies

#WORK PROCESS

# ASK

Statement: annual members are much more profitable than casual riders
Hypothesis: maximizing the number of annual members will be key to future growth
Project Goal: Design marketing strategies aimed at converting casual riders into annual members
Business Questions: how do annual members and casual riders differ in their use of Cyclistic bikes?
why would casual riders purchase membership?
how can digital media help convert casual riders to members?

# PREPARE

Source of the data: The last 12 months of Cyclistic trip data was downloaded from divvy-tripdata , and then converted the .csv files to .xlsx. The data range downloaded for use in the project was from July 2021 to June 2022.
Organization of the data: Each of the files have 13 columns of data with the following attributes: ride_id, rideable_type, started_at, ended_at, start_station_name, start_station_id, end_station_name, end_station_id, start and end coordinates, and then member_casual.

Credibility of the data: This comprehensive and regularly updated public data was collected and made available by Motivate, International Inc. under this license. The data is Reliable, Original, Comprehensive, Current and Cited.
Licensing, privacy, security, and accessibility of the data: Due to privacy considerations, the data was stripped of personal identifiable information (PII). The lack of identifiable information thus limits the extent of possible analysis, for example, there is not enough information to determine how often the casual riders use bike-share.

The data’s ability to answer business questions: There is an attribute in the data that describes the type of rider as casual or member. Casual refers to riders who pay for individual or daily rides while member refer to riders with annual subscription. This will help determine the variation in the use of the bike-share by the two groups.
The problems with the data: The apparent problems are missing fields and duplicate records.

# PROCESS and ANALYZE

In these past months, I have developed my Microsoft Excel skills further, learnt SQL and R, so I intend to use all three tools on this project.
I downloaded 12 months (July 2021 – June 2022) data; was downloaded from here.
Microsoft Excel spreadsheet was the first tool used to view and clean the data month by month. Although the data was large, it was possible to analyze each month’s data using spreadsheet. Then I tried to clean another copy of the data in SQL. Finally, I loaded another copy of the dataset into R for analysis.

## Microsoft Excel

For each month, the records were reviewed to better understand the measured values, data formats, and the context. Filter was applied to find blanks, and the data was checked to remove duplicate records. Leading and trailing spaces as well as other inaccuracies and inconsistencies were removed.
Two new columns were created
a. ride*length: to obtain the duration of each trip by calculating the difference between ended_at and started_at.
b. day_of_week: to indicate the day of the week that the ride was undertaken
c. ride_length_minutes: to convert ride_length duration to minutes
d. ride_status: to help categorize the rides based on the duration using =IF(F5> (24\*60),"Stolen", IF (F5< (60/60),"False start", "Good Ride"))
The data was then put in a table format to aid the creation of pivot tables and charts for the analysis.
The following were analyzed:
 Total number of rides per rideable_type - calculated the total rides for members and casuals separated by rideable_types, used column chart
 Total number of rides per day_of_week - calculated the total rides for members and casuals and separated it by day of the week, used a line chart
 Average ride_length - calculated the average ride length for members and casuals and separated it by rideable*¬type, used a horizontal bar chart
 Total number of rides per hour_of_day - calculated the total rides for members and casuals separated by the time of the day (24hr), column chart
 Top 10 rides per day - calculated the top 10 stations with the highest numbers of rides for members and casual separated by the day of the month, used a horizontal bar chart.
You can find the dashboard created for the analysis for the month of June 2022 here
I tried to aggregate data from all 12 months in Power Query by importing and transforming of the data. Then I removed redundant columns before combining all into a single file, and duplicate records were removed. However, I had issues creating a pivot table for analysis with the combined data. I will find time to trouble shoot the issue.

## SQL

Using Microsoft SQL Server Management Studio SSMS, I created a database – Cyclistic. Then I inserted a copy of the downloaded files by using the flat file option since the files are .csv files. Once the 12 months data were inserted, they were combined into one table and the other tables that were no more required were removed from the database.
The records were then counted to ensure that the table contains all merged data and then I checked for and removed duplicates records from the merged table.
Additional columns were created to help with analysis such as
 ride_length (the interval between the started_at and ended_at) in minutes
 day_of_week (the day of the week that each ride started)
 started_hour (the hour of the day that the ride started)
 day_of_month (the day of the month that the ride started)
 ride_status
Finally, a view of the columns relevant to the analysis was created from the table and analysis were carried out. Find the SQL code here.

## R

The process started by installing the necessary packages and installing the libraries needed.
Packages tidyverse and janitor were installed. I ended up not using the janitor as intended for cleaning the data. Libraries such as tidyverse, lubridate, hms, data.table were installed as well.
Then the data was loaded onto R and merged into a data frame. Redundant files were removed, and the data was cleaned.
New columns were created for values that are required for analysis and once the analysis was concluded, a new data frame of columns needed for visualization was created and downloaded to be loaded in the visualization medium. Find the R code for the project here

# SHARE

## VISUALIZATION ON TABLEAU

You will find the dashboard created to show the findings here.

# SUMMARY

There were a little over 4.6M riders btw July 2021 and June 2022, 57% of whom are members already. Casual bike is popular with both members and casuals; however, members have no record of docked bike.
The average length of ride in the 12 months under observation is 19.26 minutes. Although casuals recorded an average ride duration of about 28 minutes, the members had 12.63 average length of ride.
While the number of member riders peaked on Thursdays within this period, members ride the longest on Sundays with an average ride length of 14.40 minutes. Meanwhile, there are more casual riders on Saturdays than any other day, but casuals also ride the longest on Sundays with an average ride length of 32.08 minutes, which is more than twice the average of the member riders.
The highest number of rides recorded at 1700hrs (5 pm) of the day, Saturday with 788,999 number of rides is the day of week with highest rides while most rides occurred in the summer with 1,986,981 number of rides. There were lesser numbers of casual riders in January and February.

# RECOMMENDATIONS

There were some limitations in the available information due to privacy for instance, we do not have information about the users address to understand while a group of users use a certain station more and others less.
Also, understanding the geography of the city would also provide some insights as to the motivation of casual riders, which the marketing team can leverage in creating a strategy to target the casual riders.
If the company can create subscription perks that are connected to the casuals’ motivation for riding, it will encourage them to do so.
Also, since the casual riders use the service more during the weekends, and in the summer, more marketing efforts and perks should be geared towards this time and season
Furthermore, I will encourage further analysis as more information provided will help the company achieve its goals.
