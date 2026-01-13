# Eurodollar (CME) style expiry:
#   2nd London banking day before the 3rd Wednesday of the contract month.
#   Expiry time: 11:00 AM London time, converted to US/Eastern.
library(dplyr)
library(lubridate)
library(readr)
library(stringr)

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

