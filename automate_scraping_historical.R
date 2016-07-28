
update_users <- function() {
  
  #connect to db
  library(RSQLite)
  db <- dbConnect(SQLite(), "overDB.sqlite")
  
  #check validity before making moves
  if(dbIsValid(db)){
    
    #load master file of 30 day user set
    users_master <- read.csv("users_master.csv")
    
    #check that users table exists in db
    if(dbExistsTable(db,"users")) {
      
      #load table of already scraped users
      users_scraped <- dbReadTable(db, "users")
      users_scraped <- users_scraped[,-1]
      
      #get chunk of master user cohort that hasn't been scraped already
      to_scrape <- users_master[-which(users_master[,1] %in% users_scraped[,1]),]
      
      #scrape users that aren't yet in database
      scrape_amplitude(to_scrape)
      
      #scrape_amplitude continually overwrites csv file. read that csv back in after function crashes
      temp_scraped <- read.csv("temp_scraped.csv")
      temp_scraped<- temp_scraped[,-1]
      
      #append everything just scraped to users table in db
      dbWriteTable(db, "users", temp_scraped, append = TRUE)
      
      #disconnect db to ensure proper writing of users table 
      dbDisconnect(db)
      
      #success
      return (TRUE)
    }
    else {
      print("Users table does not exist.")
      return (FALSE)
    }
  }
  
  else {
    print("Database is not valid.")
    return (FALSE)
  }
}

