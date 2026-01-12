# Tick Data Processing

Pipeline for cleaning futures tick data and loading into MS SQL Server.

## Data Source

Tick data CSVs are read from external storage (`F:/TickJobs/`), configured in `Code/config.R`.

## Implemented

**Eurodollar (ED) Futures** - Processes quarterly contracts (H/M/U/Z months), calculates expiry datetime (2nd London banking day before 3rd Wednesday, 11:00 AM London time), and writes to `tick_data.dbo.ED`.

## Usage

```r
source("Code/ED.R")
```

## Dependencies

- R packages: dplyr, lubridate, timeDate, readr, stringr, purrr, DBI
- `Rnvonturk` package for database connections
