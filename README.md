# Tick Data Processing

Pipeline for cleaning futures tick data and loading into MS SQL Server.

## Data Source

Tick data CSVs are read from external storage (`F:/TickJobs/`), configured in `Code/config.R`.

## Implemented

**Eurodollar (ED) Futures** - Processes quarterly contracts (H/M/U/Z months) and writes to `tick_data.dbo.ED`.

**SOFR 3-Month (SR3) Futures** - Processes quarterly contracts (H/M/U/Z months) and writes to `tick_data.dbo.SR3`.

## Usage

```r
source("Code/ED.R")   # Eurodollar futures
source("Code/SR3.R")  # SOFR 3-month futures
```

## Dependencies

- R packages: dplyr, lubridate, timeDate, readr, stringr, purrr, DBI
- `Rnvonturk` package for database connections
