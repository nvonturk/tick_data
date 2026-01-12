# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Tick data processing pipeline for futures contracts. Reads CSVs from external storage, cleans them, and writes to MS SQL Server.

## Data Source

Tick data CSVs are stored externally at `F:/TickJobs/` (configured in `Code/config.R`), not in the repository's Data/ folder.

## Code Structure

- `Code/config.R` - Paths to external tick data directories
- `Code/utils.R` - Shared cleaning functions and expiry calculations
- `Code/ED.R` - Eurodollar futures processing script

## Database

Data is written to MS SQL Server database `tick_data` using the `Rnvonturk` package for connections.
