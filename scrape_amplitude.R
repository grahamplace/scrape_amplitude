library(rvest)
library(RSelenium)

#open browser 
checkForServer()
startServer()
browser <- remoteDriver()
browser$open()
url <- "https://amplitude.com/login"
browser$navigate(url)

#locate search bars
email_input <- browser$findElement(using = 'css selector', '#login-email')
email_input$sendKeysToElement(list("margaretlou2019@u.northwestern.edu"))
password_input <- browser$findElement(using = 'css selector', '#login-password')
password_input$sendKeysToElement(list("maggie_lou"))
button <- browser$findElement(using = 'xpath', '/html/body/div[2]/div/form/fieldset/div[3]/button')
button$clickElement()

browser$navigate("https://amplitude.com/app/146509/activity/search?userId=8408666528")
table <- browser$findElement(using = 'css selector', 'table.table.half.user-details-table')
table <- readHTMLTable(header = TRUE, table$getElementAttribute("outerHTML")[[1]])




#login-email simplified
remDr$open()
remDr$navigate(appURL)
remDr$findElement("id", "login")$sendKeysToElement(list("myusername"))
remDr$findElement("id", "pass")$sendKeysToElement(list("mypass"))
remDr$findElement("css", ".am-login-form input[type='submit']")$clickElement()