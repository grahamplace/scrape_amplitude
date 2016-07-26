library(RSelenium)

#' @return Saves a CSV to the current directory containing data on all active users from the past day.
download_yesterday <- function() {
  #login to Amplitude 
  checkForServer()
  startServer()
  browser <- remoteDriver()
  browser$open()
  browser$navigate("https://amplitude.com/login")
  browser$findElement(using = 'css selector', '#login-email')$sendKeysToElement(list("margaretlou2019@u.northwestern.edu"))
  browser$findElement(using = 'css selector', '#login-password')$sendKeysToElement(list("maggie_lou", key = 'enter'))

  browser$navigate("https://amplitude.com/app/146509/cohorts/list?folder=My%20cohorts")
  browser$findElement(using = 'xpath', '//*[@id="main"]/div/div[1]/div/div[2]/div/div[2]/div/div/table/tbody/tr/td[4]/span/i')$clickElement()
  browser$findElement(using = 'xpath', '//*[@id="main"]/div/div[1]/div/div[2]/div/div[2]/div/div/table/tbody/tr/td[6]/span/i')$clickElement()
  
}