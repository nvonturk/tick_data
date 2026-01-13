library(purrr)
library(DBI)
library(Rnvonturk)

source("Code/config.R")
source("Code/utils.R")

con <- create_connections()

# List all CSV files in SR3 tick data directory
sr3_files <- list.files(
  path = TICK_PATHS$SR3,
  pattern = "\\.csv$",
  full.names = TRUE
)

# Filter for SR3 futures contracts: SR3[H/M/U/Z]YY pattern
# H=March, M=June, U=September, Z=December
sr3_contracts <- sr3_files |>
  keep(~ str_detect(basename(.x), "^SR3[HMUZ]\\d{2}\\.csv$"))

# Drop table if it exists
sr3_table <- Id(catalog = "tick_data", schema = "dbo", table = "SR3")
if (dbExistsTable(con$sql_conn, sr3_table)) {
  dbRemoveTable(con$sql_conn, sr3_table)
}

# Clean each file and write to database
sr3_contracts |>
  walk(~ {
    df <- clean_tick_data(.x)
    dbWriteTable(con$sql_conn, sr3_table, value = df, append = TRUE)
    cat("Done:", basename(.x), "\n")
  })

