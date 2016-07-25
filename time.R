df <- data.frame(activity = "1":"2", do = 1:10, wish = 1:10)
df$activity <- as.character(df$activity)
df$do <- as.integer(df$do)
df$wish <- as.integer(df$wish)
class(df$activity)
df$activity <- c("Sleep", "Eat", "Exercise", "Study", "Read", "Homework", "Class", "Personl Projects", "Family Time", "Friend Time")
df$do <-0 
df$wish <- 0
View(df)

library(ggplot2)
ggplot(df, aes(x = do, y = wish, color = activity)) + geom_point() + labs()

