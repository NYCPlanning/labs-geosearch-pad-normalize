args <- commandArgs(trailingOnly=TRUE)
defaultPadVersion <- "19a"
if(length(args) == 0) {
  print(paste("No PAD version specified. Using default", defaultPadVersion))
  padVersion <- defaultPadVersion
} else{
  padVersion <- args[1]
  print(paste("Using PAD version: ", padVersion))
}

# Define location of specified PAD version
source <- paste("https://www1.nyc.gov/assets/planning/download/zip/data-maps/open-data/pad", padVersion, ".zip", sep="")

# Define query for all bbl-centroid pairs in latest PLUTO data in Carto
bblQuery <- "SELECT
  bbl,
  Round(ST_X(ST_Centroid(the_geom))::numeric,5) AS lng,
  Round(ST_Y(ST_Centroid(the_geom))::numeric,5) AS lat
FROM mappluto"
bblcentroids <- paste("https://planninglabs.carto.com/api/v2/sql?q=", URLencode(bblQuery), "&format=csv", sep="")

# Define query for all bin-centroid pairs in latest Building Footprints data in Carto 
binQuery <- "SELECT
  bin::text,
  Round(ST_X(ST_Centroid(the_geom))::numeric,5) AS lng,
  Round(ST_Y(ST_Centroid(the_geom))::numeric,5) AS lat
FROM planninglabs.building_footprints"
bincentroids <- paste("https://planninglabs.carto.com/api/v2/sql?q=", URLencode(binQuery), "&format=csv", sep="")

# Download PAD
download(source, dest="data/dataset.zip", mode="wb")

# Run queries
download(bblcentroids, dest="data/bblcentroids.csv", mode="wb")
download(bincentroids, dest="data/bincentroids.csv", mode="wb")

# Unzip PAD
unzip("data/dataset.zip", exdir = "./data")
