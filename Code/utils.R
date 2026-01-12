# Eurodollar (CME) style expiry:
#   2nd London banking day before the 3rd Wednesday of the contract month.
#   Expiry time: 11:00 AM London time, converted to US/Eastern.
library(dplyr)
library(lubridate)
library(timeDate)
library(readr)
library(stringr)
library(hms)

# Contract month letter codes (IMM months for ED futures)
CONTRACT_MONTH_CODES <- c(
  H = "March",
  M = "June",
  U = "September",
  Z = "December"
)

# Numeric month mapping for expiry calculation
CONTRACT_MONTH_NUMBERS <- c(
  H = 3L,
  M = 6L,
  U = 9L,
  Z = 12L
)

#' Clean tick data CSV file
#'
#' @param filepath Path to tick data CSV file
#' @return Tibble with cleaned columns
clean_tick_data <- function(filepath) {
  read_csv(
    filepath,
    col_types = cols(
      .default = col_character(),
      Price = col_double(),
      Volume = col_integer()
    ),
    show_col_types = FALSE
  ) |>
    rename_with(~ .x |> tolower() |> str_replace_all(" ", "_")) |>
    mutate(date = mdy(date))
}

#' Find the 3rd Wednesday of a given month
third_wednesday <- function(year, month) {
  # Start at the 1st of the month
  d <- make_date(year, month, 1)
  # Find first Wednesday
  days_until_wed <- (4 - wday(d, week_start = 1)) %% 7
  first_wed <- d + days_until_wed
  # 3rd Wednesday is 2 weeks later
  first_wed + weeks(2)
}

#' Check if a date is a London banking day
is_london_banking_day <- function(d) {
  # Must be a weekday (Mon-Fri)
  if (wday(d, week_start = 1) > 5) return(FALSE)
  # Must not be a London bank holiday
  hols <- as.Date(holidayLONDON(year(d)))
  !(d %in% hols)
}

#' Get the previous London banking day
prev_london_banking_day <- function(d) {
  d <- d - days(1)
  while (!is_london_banking_day(d)) d <- d - days(1)
  d
}

#' Get Eurodollar futures expiry datetime in US/Eastern
#'
#' @param year Contract year
#' @param month Contract month
#' @return POSIXct datetime of expiry in US/Eastern timezone
ed_expiry <- function(year, month) {
  imm <- third_wednesday(year, month)
  d1 <- prev_london_banking_day(imm)
  expiry_date <- prev_london_banking_day(d1)

  # Expiry is 11:00 AM London time
  expiry_london <- ymd_hms(
    paste(expiry_date, "11:00:00"),
    tz = "Europe/London"
  )

  # Convert to US/Eastern
  with_tz(expiry_london, tzone = "US/Eastern")
}
