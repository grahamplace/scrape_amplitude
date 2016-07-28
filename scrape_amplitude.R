library(rvest)
library(RSelenium)
library(reshape2)
library(dplyr)


#' @param t A table holding the user IDs for which data must be scraped. 
#' @return A dataframe holding all customer data for the IDs in the input table. 
scrape_amplitude <- function(t) {
  #randomly sample data points
  index <- sample(1:nrow(t), nrow(t))
  input <- t[index,]
  
  #login to Amplitude
  checkForServer()
  startServer()
  browser <- remoteDriver()
  browser$open()
  browser$navigate("https://amplitude.com/login")
  browser$findElement(using = 'css selector', '#login-email')$sendKeysToElement(list("margaretlou2019@u.northwestern.edu"))
  browser$findElement(using = 'css selector', '#login-password')$sendKeysToElement(list("maggie_lou", key = 'enter'))
    # button <- browser$findElement(using = 'xpath', '/html/body/div[2]/div/form/fieldset/div[3]/button')
    # button$clickElement()
  Sys.sleep(20)
  
  #scrape tables
  customer.frame <- c()
  for (i in 1:length(input$amplitude_id)) {
    print(input$amplitude_id[i])
    #scrape data from Amplitude
    temp <- grab_customer.data(input$amplitude_id[i], browser)
    print(i)
    
    # add data from input csv
    temp <- cbind(temp, input[i,])[,-1]
    
    #add to existing table
    if(i==1) {
      customer.frame <- temp
    } else {
      customer.frame <- rbind(customer.frame, temp)
    }
    
    write.csv(customer.frame , file = "temp_scraped2.csv")
  }
    browser$close()
    
    return(customer.frame)
  
  }
  
  
  
  #' @param customer_id An int representing user ID.
  #' @return A dataframe holding the customer data for the input user.
  grab_customer.data <- function(user_id, browser){
    #scrape table
    print(user_id)
    browser$navigate(paste("https://amplitude.com/app/146509/activity/search?userId=", user_id, sep=""))
    Sys.sleep(20)
    cust_table <- browser$findElement(using = 'css selector', 'table.table.half.user-details-table')
    cust_table <- readHTMLTable(header = FALSE, cust_table$getElementAttribute("outerHTML")[[1]])[[1]][2] %>% t() %>% as.data.frame()
    names(cust_table) <- c("User_ID", "Amplitude_ID", "Merged_ID", "Total_Events", "Total_Sessions", "Usage_Time", "First_Seen", "Last_Seen", "Num_Purchases", "Total_Spent")
    return(cust_table)
}
