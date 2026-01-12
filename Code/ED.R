library(purrr)
library(DBI)
library(Rnvonturk)

source("Code/config.R")
source("Code/utils.R")

con <- create_connections()

# List all CSV files in ED tick data directory
ed_files <- list.files(
  path = TICK_PATHS$ED,
  pattern = "\\.csv$",
  full.names = TRUE
)

# Filter for ED futures contracts: ED[H/M/U/Z]YY pattern
# H=March, M=June, U=September, Z=December
ed_contracts <- ed_files |>
  keep(~ str_detect(basename(.x), "^ED[HMUZ]\\d{2}\\.csv$"))

# Drop table if it exists
ed_table <- Id(catalog = "tick_data", schema = "dbo", table = "ED")
if (dbExistsTable(con$sql_conn, ed_table)) {
  dbRemoveTable(con$sql_conn, ed_table)
}

# Clean each file and write to database
ed_contracts |>
  walk(~ {
    df <- clean_tick_data(.x)

    # Extract contract info from first row's symbol
    symbol <- df$symbol[1]
    month_letter <- str_extract(symbol, "(?<=ED)[HMUZ]")
    contract_month <- CONTRACT_MONTH_CODES[month_letter]
    contract_year <- as.integer(paste0("20", str_extract(symbol, "\\d{2}$")))

    df |>
      mutate(
        contract_month = contract_month,
        contract_year = contract_year
      ) |>
      dbWriteTable(con$sql_conn, ed_table, value = _, append = TRUE)

    cat("Done:", basename(.x), "\n")
  })
