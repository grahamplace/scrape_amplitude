#' @param t A dataframe holding user information. 
#' @return A cleaned user data frame including additional columns that have been feature engineered. 
clean_users <- function(t) {
  library(dplyr)
  library(stringr)
  
  #see classes of variables
  #sapply(t, class)
  
  #Remove erroneous columns
  t <- t%>% select(Amplitude_ID, Total_Events, Total_Sessions, Usage_Time, First_Seen, Last_Seen, Num_Purchases, Total_Spent, user_id, carrier, city, country, device, device_type, dma, ip_address, language, library, os, paying, platform, region, start_version, version, gp.Active.Projects, gp.Collected.Daily.Artwork, gp.camera_permission, gp.camera_roll_count, gp.daily_artwork_count, gp.photos_permission, gp.project_count, gp.push_enabled)
  
  #Fix erroneous classifications
  t$Amplitude_ID <- as.character(t$Amplitude_ID)
  t$Total_Events <- as.numeric(gsub("\\+", "", as.character(t$Total_Events)))
  t[which(is.na(t$Total_Events)), 2] <- 0
  t$Total_Sessions <- as.numeric(gsub("\\+", "", as.character(t$Total_Sessions)))
  t[which(is.na(t$Total_Sessions)), 3] <- 0
  
  #usage time in minutes 
  t$Usage_Time<-as.character(t$Usage_Time)
  for (i in 1:length(t$Usage_Time)) {
    t$Usage_Time[i] <- fix_usage.time(t$Usage_Time[i])
  }
  t$Usage_Time <- as.numeric(t$Usage_Time)
  colnames(t)[4] <- "Usage_Min"
  
  #Fix dates
  library(lubridate)
  t$First_Seen <- mdy(t$First_Seen)
  t$Last_Seen <- mdy(t$Last_Seen)
  
  #continute fixing classes
  t$Num_Purchases <- as.numeric(gsub("\\+", "", as.character(t$Num_Purchases)))
  
  t$Total_Spent <- as.character(t$Total_Spent)
  t$Total_Spent <- sub("\\$", "", t$Total_Spent)
  t$Total_Spent <- sub("\\+", "", t$Total_Spent)
  t$Total_Spent <- as.numeric(t$Total_Spent)
  
  t$user_id <- as.character(t$user_id)
  t$city <- as.character(t$city)
  t$device <- as.character(t$device)
  t$device_type <- as.character(t$device_type)
  index <- which(t$device_type=="")
  t$device_type[index] <- as.character(t$device[index])
  
  for(c in index){
    t$device[c] <- t$device[c] %>% word(start =1, end = 2, sep = fixed(" "))
  }
  
  t$device <- str_trim(t$device, side = "right")
  
  t$device <- as.factor(t$device)
  t$device_type <- as.factor(t$device_type)
  
  t$ip_address <-as.character(t$ip_address)
  
  #Fix booleans 
  t$paying <- as.character(t$paying)
  t$paying <- ifelse(t$paying == "true", TRUE, FALSE)
  
  t$region <- as.character(t$region)
  
  t$gp.Active.Projects[which(is.na(t$gp.Active.Projects))] <- 0
  t$gp.Collected.Daily.Artwork[which(is.na(t$gp.Collected.Daily.Artwork))] <- 0
  t$gp.push_enabled <- as.character(t$gp.push_enabled)
  t$gp.push_enabled <- ifelse(t$gp.push_enabled == "TRUE", TRUE, FALSE)
  t$gp.camera_permission <- as.character(t$gp.camera_permission)
  t$gp.camera_permission <- ifelse(t$gp.camera_permission == "true", TRUE, FALSE)
  t$gp.photos_permission <- as.character(t$gp.photos_permission)
  t$gp.photos_permission <- ifelse(t$gp.photos_permission == "true", TRUE, FALSE)
  t$gp.daily_artwork_count[which(is.na(t$gp.daily_artwork_count))] <- 0
  t$gp.project_count[which(is.na(t$gp.project_count))] <- 0
  
  t$gp.camera_roll_count[which(t$gp.photos_permission == FALSE)] <- NA
  
  
  #fix any users marked paying = FALSE but total_paid > 0:
  t$paying[which(t$paying == FALSE & t$Total_Spent > 0)] <- TRUE
  
  return(t)
  
  
  
  #possible features: ############
  #Add average time spent on app : total_sessions / usage_time
  #Add user age 
  #has collected daily artwork boolean
  #tag users with their quintile of spending, engagement, user age, project_count 
  #Add user engagement - total_events / total_sessions 
  
  
  
  
  
  #' Notes: 
  #' - Total_Spent : $10.91+ 
  #subset top purchasers - what are their characteristics 
  
}


#' @param time A string representing usage time.
#' @return A character representing usage time in numeric minutes.
fix_usage.time <- function(time) {
  if (grepl("second",time)) {
    time <- 0.5
  } else if (grepl("minute",time)) {
    time <- gsub("a", "1", time)
    time <- gsub(" .*","",time)
  } else if (grepl("hour",time)){
    time <- gsub("an", "1", time)
    time <- gsub(" .*","",time)
    time <- as.character(as.numeric(time) * 60)
  } else {
    time <- 0
  }
}