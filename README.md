# labs-pad-normalize 
![CI](https://github.com/NYCPlanning/labs-geosearch-pad-normalize/workflows/CI/badge.svg)

R script to normalize PAD data into discrete address records.  Part of the [NYC Geosearch Geocoder Project](https://geosearch.planninglabs.nyc/)

# Introduction
The NYC Geosearch API is built on [Pelias](https://www.pelias.io/), the open source geocoding engine that powered Mapzen Search. To accomplish this, we use the authoritative Property Address Directory (PAD) data from the NYC Department of City Planning's Geographic Systems Section. However, because the data represent _ranges_ of addresses, the data must be normalized into an "expanded" form that Pelias will understand. This expansion process involves many factor-specific nuances that translate the ranges into discrete address rows. This "normalizer" outputs a CSV file that conforms to the schema laid out by Pelias' offical [CSV Importer](https://github.com/pelias/csv-importer). As per the CSV importer's documentation, the CSVs include a column called `addendum_json_pad` that includes stringified JSON of custom fields we need to include, such as `bbl` and `bin`. This JSON also includes a `version` property so that JSON responses from the Geosearch API tell consumers which version of PAD was used to create the data they are receiving.

Note that this repo is only responsible for _building and uploading_ a dataset that will eventually be loaded into the ElasticSearch database underpinning our instance of Pelias that makes up the product we refer to as "Geosearch". If you need to deploy a new version of Geosearch using a new version of PAD, use this repo to get a new `labs-geosearch-pad-normalized.csv` file uploaded to Digital Ocean, then refer to [labs-geosearch-docker](https://github.com/NYCPlanning/labs-geosearch-docker) for steps on how to build a deploy a new geosearch Droplet that uses the data you just created and uploaded.


# Data
This script downloads a version of the PAD data from [NYC's Bytes of the Big Apple](https://www1.nyc.gov/site/planning/data-maps/open-data.page). The Property Address Directory (PAD) contains geographic information about New York City’s approximately one million tax lots (parcels of real property) and the buildings on them.  PAD was created and is maintained by the Department of City Planning’s (DCP’s) Geographic Systems Section (GSS).  PAD is released under the BYTES of the BIG APPLE product line four times a year, reflecting tax geography changes, new buildings and other property-related changes.

The zip file downloaded in `_download_data.R` for PAD also includes a copy of the [Street Name Directory (SND)](https://www.nyc.gov/site/planning/data-maps/open-data.page#snd) which includes various street data.

In addition to the data found in the PAD zip file, `_download_data.R` also downloads MapPLUTO data from the `nycplanning-web` (username `planninglabs`) Carto instance and "building footprint" data from the City's [Open Data Portal](https://data.cityofnewyork.us/Housing-Development/Building-Footprints/nqwf-w8eh).

# R Script
This script will output four CSV files to the `/data/nycpad` directory - the full output will be in `labs-geosearch-pad-normalized.csv` along with truncates small, medium, and large versions of the output to help with local development.
# How to run locally
Make sure R is installed on your machine. If you just want CLI stuff:
```sh
$ brew install R
```
Install necessary packages
```sh
$ R
> install.packages(c("tidyverse", "jsonlite", "downloader", "sf"))
```
(Note: this may take a long time. Go get a coffee or something)

Run the R script to normalize the new PAD data:
```sh
$ Rscript ./main.R
```

To skip the costly step of re-downloading data on every attempt, you can run:
```sh
$ Rscript ./main_skip_download.R
```

Due to the nature of the PAD dataset, it is very likely that some data processing may be incompatible with new versions. At the very least, it if likely new entries will need to be added to the [suffix lookup table data](https://github.com/NYCPlanning/labs-geosearch-pad-normalize/blob/main/suffix_lookup.csv). Do not dispair. Use RStudio to step thru the munging process one step at a time. You'll get there. You got this!

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
# How to update data in the "production" Digital Ocean Space
This project is run in "production" via Github Actions. The workflow found in `/.github/workflows/main.yml`  will pick up the version of pad from `version.env`. In order to upload new data to Digital Ocean:
* Create a branch off of `main` and change the pad version listed in `version.env`
* Push your branch to GH and open a PR against `main`. The GH action workflow in `/.github/workflows/main.yml` will attempt to build the dataset on pushes to _all_ branches, not just `main`. However, it will only attempt to _upload_ the output (by running `push-to-bucket.sh`) to Digital Ocean on pushes to `main`. You can use this to check that the Actions running your feature branch appear to build the dataset successfully before merging into `main`.
* Once your PR is approved, you can merge it. Merging will kick off another the workflow again which, if successful, will upload the updated dataset to the corresponding Digital Ocean space.

