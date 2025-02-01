library(tidyverse)
library(rvest)

## Script options

## How many back-copies of the database do you want to download? They
## have a little over 600 available as of 2025-01-31, so if you want
## to get all of them, set it to 10000 or something. But if you only
## want the last 10 days' worth, leave it at 10.
copies_to_download <- 10

## Number of minutes to allow for downloading of a single file (one
## copy of the database is about 2 GB)
download_timeout <- 30

## Base directory for where to save downloaded data (include trailing
## slash)
base_dir <- "~/Downloads/"

## The rest probably shouldn't need to be changed

## Get the timeout setting
original_timeout <- getOption('timeout')
## Set it to the number of minutes specified above
options(timeout=60*download_timeout)

## Download the HTML for the index page
page <- read_html("https://aact.ctti-clinicaltrials.org/download")

## Base URL for file download
base_url <- "https://aact.ctti-clinicaltrials.org"

## Download the page HTML and pull out the links
links <- page %>%
  html_elements(".form-select option a") %>%
  html_attr("href")

## Remove the Covid-19 studies (redundant)
links <- links[-grep("^/static/covid-19", links)]

## Remove the Pipe-delimited files (redundant)
links <- links[-grep("^/static/exported_files", links)]

## Limit the number to be downloaded
links <- head(links, n = copies_to_download)

## Loop through all the links downloaded
for (i in 1:length(links)) {

  ## Construct the filename for the local download target
  filename <- paste0(
    substr(links[[i]], nchar(links[[i]])-9, nchar(links[[i]])),
    "-clinicaltrials.gov.zip"
  )

  ## Check whether the file is there already
  if (! file.exists(paste0(base_dir, filename))) {

    ## File isn't already there, tell the user that download is
    ## starting
    message(
      paste(
        "Downloading", filename
      )
    )

    ## Download the file into the specified filename
    download.file(
      paste0(base_url, links[[1]]),  
      paste0(base_dir, filename)
    )
    
  } else { ## A file with that name is already on disk

    ## Tell the user
    message(
      paste(
        filename,
        "already exists; not downloading"
      )
    )
    
  }
  
}

## Restore the original timeout
options(timeout=original_timeout)
