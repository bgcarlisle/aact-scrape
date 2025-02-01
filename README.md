# aact-scrape

This is a tool to automate downloading of the full database of
ClinicalTrials.gov data from AACT.

## Requirements

*R* packages: `tidyverse` and `rvest`.

## How to use

There's 3 variables at the top of the script that you're most likely
to want to modify:

1. `copies_to_download`, which tells the script how many days of
   back-copies to try to download
2. `download_timeout`, which tells *R* how many minutes to keep trying
   to download each file (default 10)
3. `base_dir`, the local path for where *R* should try to save the
   downloaded files
