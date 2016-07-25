URL <- "https://amplitude.com/app/146509/activity/search?userId=5547129680"

library(XML)
df <- readHTML(URL, which = 1, stringsAsFactors = FALSE)

library(rvest)
amplitude <- read_html(URL)
test <- amplitude %>% html_nodes("#main > div > div.main-content.ng-scope > div > div.ng-scope > div:nth-child(1) > div.loading-wrapper.ng-isolate-scope > div.loading-window > div > div:nth-child(1) > table:nth-child(1) > tbody > tr:nth-child(2) > td.ellipsis-overflow.ng-binding")

library(RSelenium)
checkForServer()
startServer()
browser <- remoteDriver(browserName = "chrome")
browser$open()
browser$navigate("http://www.google.com")
browser$getCurrentUrl()
browser$getTitle()
# Locate the input field using a CSS selector.
input <- browser$findElement(using = 'css selector', "#lst-ib")
input$sendKeysToElement(list("CRAN Selenium"))


library(httr)
library(XML)

handle <- handle("https://amplitude.com/login") 
path   <- "amember/login.php"

# fields found in the login form.
login <- list(
  amember_login = "grahamgplace@gmail.com"
  ,amember_pass  = "leopardskloof"
  ,amember_redirect_url = "https://amplitude.com/app/146509/activity/search?userId=5508109519"
)

response <- POST(handle = handle, path = path, body = login)
