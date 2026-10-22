# Bike Share Analysis: Chicago, New York City, and Washington

first_existing <- function(candidates) {
  found <- candidates[file.exists(candidates)]
  if (length(found) == 0) stop("A required dataset file is missing.")
  found[1]
}

read_city <- function(path, city_name) {
  d <- read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  core <- c("Start Time", "End Time", "Trip Duration", "Start Station",
            "End Station", "User Type")
  if (!all(core %in% names(d))) stop(paste("Required columns missing from", path))
  d <- d[, core]
  d$City <- city_name
  d$StartDateTime <- as.POSIXct(d[["Start Time"]],
                                format = "%Y-%m-%d %H:%M:%S", tz = "UTC")
  d$Month <- format(d$StartDateTime, "%B")
  d$Weekday <- factor(weekdays(d$StartDateTime),
                      levels = c("Monday", "Tuesday", "Wednesday", "Thursday",
                                 "Friday", "Saturday", "Sunday"), ordered = TRUE)
  d$Hour <- as.integer(format(d$StartDateTime, "%H"))
  d[["Trip Duration"]] <- as.numeric(d[["Trip Duration"]])
  d$UserTypeClean <- ifelse(is.na(d[["User Type"]]) | d[["User Type"]] == "",
                            "Missing", d[["User Type"]])
  d[!is.na(d$StartDateTime) & !is.na(d[["Trip Duration"]]), ]
}

files <- c(first_existing("chicago.csv"),
           first_existing(c("new-york-city.csv", "new_york_city.csv")),
           first_existing("washington.csv"))
cities <- c("Chicago", "New York City", "Washington")
city_data <- Map(read_city, files, cities)
bikes <- do.call(rbind, city_data)
row.names(bikes) <- NULL

stopifnot(nrow(bikes) == 900000)
stopifnot(length(unique(bikes$City)) == 3)

mode_and_count <- function(x) {
  counts <- table(x, useNA = "no")
  winner <- which.max(counts)
  c(Value = names(counts)[winner], Trips = as.integer(counts[winner]))
}

popular_times <- do.call(rbind, lapply(split(bikes, bikes$City), function(d) {
  month <- mode_and_count(d$Month)
  day <- mode_and_count(d$Weekday)
  hour <- mode_and_count(d$Hour)
  data.frame(City = d$City[1], MostCommonMonth = month["Value"],
             MonthTrips = month["Trips"], MostCommonDay = day["Value"],
             DayTrips = day["Trips"], MostCommonHour = hour["Value"],
             HourTrips = hour["Trips"], row.names = NULL)
}))
print(popular_times, row.names = FALSE)

hourly <- as.data.frame(table(City = bikes$City, Hour = bikes$Hour))
hourly$Hour <- as.integer(as.character(hourly$Hour))
plot(NULL, xlim = c(0, 23), ylim = range(hourly$Freq),
     main = "Bike-Share Trips by Start Hour and City",
     xlab = "Hour of day (24-hour clock)", ylab = "Number of trips")
plot_colors <- c("#2563EB", "#E85D75", "#16A085")
for (i in seq_along(cities)) {
  z <- hourly[hourly$City == cities[i], ]
  lines(z$Hour, z$Freq, type = "o", col = plot_colors[i], lwd = 2, pch = 16)
}
legend("topleft", legend = cities, col = plot_colors, lty = 1, pch = 16,
       title = "City", bty = "n")

duration_summary <- do.call(rbind, lapply(split(bikes, bikes$City), function(d) {
  seconds <- d[["Trip Duration"]]
  data.frame(City = d$City[1], Trips = length(seconds),
             TotalHours = sum(seconds) / 3600,
             MeanMinutes = mean(seconds) / 60,
             MedianMinutes = median(seconds) / 60)
}))
print(duration_summary, row.names = FALSE, digits = 2)

duration_matrix <- t(as.matrix(duration_summary[, c("MeanMinutes", "MedianMinutes")]))
colnames(duration_matrix) <- duration_summary$City
barplot(duration_matrix, beside = TRUE, col = c("#2563EB", "#F59E0B"),
        main = "Mean and Median Trip Duration by City", xlab = "City",
        ylab = "Trip duration (minutes)", legend.text = c("Mean", "Median"))

user_counts <- as.data.frame(table(City = bikes$City,
                                   UserType = bikes$UserTypeClean))
user_counts <- user_counts[user_counts$Freq > 0, ]
names(user_counts)[3] <- "Trips"
city_totals <- aggregate(Trips ~ City, user_counts, sum)
user_summary <- merge(user_counts, city_totals, by = "City",
                      suffixes = c("", "Total"))
user_summary$Percent <- 100 * user_summary$Trips / user_summary$TripsTotal
print(user_summary[, c("City", "UserType", "Trips", "Percent")],
      row.names = FALSE, digits = 4)

user_matrix <- prop.table(table(bikes$UserTypeClean, bikes$City), margin = 2) * 100
barplot(user_matrix, col = c("#F59E0B", "#16A085", "#9CA3AF", "#2563EB"),
        main = "User Type Composition by City", xlab = "City",
        ylab = "Share of trips (%)", ylim = c(0, 100),
        legend.text = rownames(user_matrix))

weekday_counts <- as.data.frame(table(City = bikes$City,
                                      Weekday = bikes$Weekday))
names(weekday_counts)[3] <- "Trips"
weekday_counts$Percent <- ave(weekday_counts$Trips, weekday_counts$City,
                              FUN = function(x) 100 * x / sum(x))
weekday_peaks <- do.call(rbind, lapply(split(weekday_counts, weekday_counts$City),
                                      function(d) d[which.max(d$Trips), ]))
print(weekday_peaks, row.names = FALSE, digits = 4)
