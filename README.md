# labs-pad-normalize 
![CI](https://github.com/NYCPlanning/labs-geosearch-pad-normalize/workflows/CI/badge.svg)

R script to normalize PAD data into discrete address records.  Part of the [NYC Geosearch Geocoder Project](https://github.com/NYCPlanning/labs-geosearch-dockerfiles)

# Introduction
The NYC Geosearch API is built on Pelias, the open source geocoding engine that powered Mapzen Search. To accomplish this, Labs uses the authoritative Property Address Directory (PAD) data from the NYC Department of City Planning's Geographic Systems Section. However, because the data represent _ranges_ of addresses, the data must be normalized into an "expanded" form that Pelias will understand. This expansion process involves many factor-specific nuances that translate the ranges into discrete address rows.  
<img width="1335" alt="screen shot 2018-01-18 at 2 48 09 pm" src="https://user-images.githubusercontent.com/1833820/35636336-d944fb22-067e-11e8-800c-65ca2100a67b.png">


We are treating the normalization of the PAD data as a separate data workflow from the [PAD Pelias Importer](https://github.com/NYCPlanning/labs-geosearch-pad-importer). This script starts with the published PAD file, and outputs a normalized CSV of discrete addresses, ready to be picked up by the importer.

# Data
This script downloads a version of the PAD data from [NYC's Bytes of the Big Apple](https://www1.nyc.gov/site/planning/data-maps/open-data.page). The Property Address Directory (PAD) contains geographic information about New York City’s approximately one million tax lots (parcels of real property) and the buildings on them.  PAD was created and is maintained by the Department of City Planning’s (DCP’s) Geographic Systems Section (GSS).  PAD is released under the BYTES of the BIG APPLE product line four times a year, reflecting tax geography changes, new buildings and other property-related changes. 

# R Script
This script will output a file in the `/data` directory called `final.csv`. This is the expanded output. To make sure the script is getting the latest version of PAD, check that the [`source`](https://github.com/NYCPlanning/labs-pad-normalize/blob/master/munge.R#L8) is pointing to the most updated version of PAD. 

# Status
The script is incomplete! Find sample output [here](https://github.com/NYCPlanning/labs-pad-normalize/blob/master/pad-sample.csv). Over the coming weeks, it should be finalized. 

# Deploy
To "deploy" data as the source for the geosearch importer, run `npm run deploy`. You must have s3cmd configured as it will run that command to upload output files. To setup for Digital Ocean spaces, see: https://www.digitalocean.com/community/tutorials/how-to-configure-s3cmd-2-x-to-manage-digitalocean-spaces.

For a new version of pad, two references to files need to be updated.  In `download_data` ensure that the download link points to the latest PAD version (17D, 18A, etc) and `load_data` make sure the path to the street name dictionary (snd17Dcow.txt, snd18Acow.txt, etc) reflects the current release.

# How to run locally
Make sure R is installed on your machine. If you just want CLI stuff:
```sh
$ brew install R
```
Install necessary packages
```sh
$ R
> install.packages(c("tidyverse", "jsonlite", "downloader"))
```
(Note: this may take a long time. Go get a coffee or something)

Run the R script to normalize the new PAD data:
```sh
$ Rscript ./munge.R
```
Due to the nature of the PAD dataset, it is very likely that some data processing may be incompatible with new versions. At the very least, it if likely new entries will need to be added to the [suffix lookup table data](https://github.com/NYCPlanning/labs-geosearch-pad-normalize/blob/develop/suffix_lookup.csv). Do not dispair. Use RStudio to step thru the munging process one step at a time. You'll get there. You got this!

If you're happy with your data, push it to digital ocean using the included shell script:
```sh
$ ./push-to-bucket.sh
```
# How to run if you have Docker installed
1. Make sure you check the Bytes of Big Apple for the latest version of PAD (replace 20a with the latest version)
```
docker build --tag pad-normalize .
```
2. Once the build is complete
```
docker run -v $(pwd)/data:/usr/local/src/scripts/data pad-normalize 20d
```
or in detached mode:
```
docker run -v $(pwd)/data:/usr/local/src/scripts/data -d pad-normalize 20d
```
# How to run in Github Actions
Github actions will pick up the version of pad from `version.env`, so please remember to update the pad version in this file before commit
```
git add .
git commit -m '[build]'
git push origin master
```
> github actions will look at the commit message and only trigger a workflow if `[build]` is mentioned.

