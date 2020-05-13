# Define location of specified PAD version
source <- paste("https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/pad", padVersion, ".zip", sep="")
# Download PAD
download(source, dest=paste0(dataDir, "/dataset.zip"), mode="wb")
# Unzip PAD
unzip(paste0(dataDir, "/dataset.zip"), exdir = dataDir)

# Define query for all bbl-centroid pairs in latest PLUTO data in Carto
bblQuery <- "SELECT
  bbl,
  Round(ST_X(ST_Centroid(the_geom))::numeric,5) AS lng,
  Round(ST_Y(ST_Centroid(the_geom))::numeric,5) AS lat
FROM mappluto"

# Define download URL for downloading PLUTO data (BBL centroids)
bblcentroids <- paste("https://planninglabs.carto.com/api/v2/sql?q=", URLencode(bblQuery), "&format=csv", sep="")

# Download PLUTO data
download(bblcentroids, dest=paste0(dataDir, "/bblcentroids.csv"), mode="wb")

# Import the `httr` library for making HTTP requests
library(httr)

# Make a GET request on the building footprints' parent (and constant) ID
r <- GET('https://data.cityofnewyork.us/api/views/nqwf-w8eh')

# Define list of IDs belonging to all of the child views this dataset has
ids <- strsplit(content(r)$metadata$geo$layers, ",")

# Define the child view ID for BIN centroids
view_id <- ids[[1]][length(ids[[1]])]

# Define source URL for downloading building footprints data (BIN centroids)
bincentroids <- paste("https://data.cityofnewyork.us/api/views/", view_id, "/rows.csv?accessType=DOWNLOAD", sep="")

# Download building footprints data
download(bincentroids, dest=paste0(dataDir, "/bincentroids.csv"), mode="wb")
