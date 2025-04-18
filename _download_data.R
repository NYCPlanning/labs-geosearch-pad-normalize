# Increase timeout to 600 -> 10 min
options(timeout=600)
# Define location of specified PAD version
source <- paste("https://s-media.nyc.gov/agencies/dcp/assets/files/zip/data-tools/bytes/pad_", padVersion, ".zip", sep="")
# Download PAD
download(source, dest=paste0(dataDir, "/dataset.zip"), mode="wb")
# Unzip PAD
unzip(paste0(dataDir, "/dataset.zip"), exdir = dataDir)

# Define query for all bbl-centroid pairs in latest PLUTO data in Carto
bblQuery <- "SELECT
  bbl,
  Round(ST_X(ST_Centroid(the_geom))::numeric,5) AS lng,
  Round(ST_Y(ST_Centroid(the_geom))::numeric,5) AS lat
FROM dcp_mappluto"

# Define download URL for downloading PLUTO data (BBL centroids)
bblcentroids <- paste("https://planninglabs.carto.com/api/v2/sql?q=", URLencode(bblQuery), "&format=csv", sep="")

# Download PLUTO data
download(bblcentroids, dest=paste0(dataDir, "/bblcentroids.csv"), mode="wb")

# Import the `httr` library for making HTTP requests
library(httr)

# Download entire building footprint dataset from open data as csv. Limit manually set to include all records.
buildingFootprintsEndpoint = "http://data.cityofnewyork.us/resource/5zhs-2jue.csv?$limit=2000000"

# Download building footprints data
download(buildingFootprintsEndpoint, dest=paste0(dataDir, "/buildingFootprints.csv"), mode="wb")