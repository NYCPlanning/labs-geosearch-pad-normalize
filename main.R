source('_globals.R')
source('_dependencies.R')
source('_functions.R')
source('_download_data.R')
source('_load_data.R')
source('_clean.R')
source('_filter.R')
source('_classify.R')
source('_sequence.R')
source('_expand.R')
source('_check.R')
source('_prepare.R')
source('_write.R')

# "CHECKING EXPANSION COLUMN FOR NON-NULL/NON-NA TYPES: " %>% print
# # For debugging, check if there were any rows that were missed in the iteration. 
# pad %>% distinct(typeof(houseNums)) %>% print

# "EXPANDING" %>% print
# # Filter out rows with missing lat or long values
# expanded <- pad %>%
#   filter(!is.na(lat) & !is.na(lng))

# This step unnests the data frame into the expanded form. It first creates a new column
# that splits the comma-separated string into an R-native list that is used for unnest. 
# It then does any other unnests.
# Two unnests are performed here: first, the interpolations, then an unnest for the LGC join keys
# After the latter joinkey is created, it performs an inner_join.
# Using unnest_legacy to improve performance

# unnest <- unnest_legacy
# expanded <- expanded %>% 
#   mutate(houseNum = strsplit(houseNums, ',')) %>%
#   unnest(houseNum) %>% 
#   mutate(lgc = strsplit(gsub("(.{2})", "\\1,", validlgcs), ',')) %>% 
#   unnest(lgc) %>%
#   inner_join(snd, by=c('boro', 'sc5', 'lgc'))
# gc() 

# Add JSON-formatted string column for csv-import "addendum" with bbl and bin and
# add name and source fields expected by csv-importer
# https://github.com/pelias/csv-importer#custom-data
# expanded <- expanded %>% 
#   mutate(addendum_json_pad = paste('{"bbl":', bbl, ',"bin":',bin,'}', sep = "")) %>%
#   mutate(name = str_trim(paste(houseNum, alt_st_name, sep=" "),side=c("both"))) %>%
#   mutate(source = "nycpad")

# # Debugging messages about type distribution
# pad %>% group_by(rowType) %>% summarise(count = length(rowType)) %>% print
# expanded %>% group_by(rowType) %>% summarise(count = length(rowType)) %>% print
# gc() 
# Simply selects only needed columns for checks and output, renaming columns to match column names expected by csv-importer.
# https://github.com/pelias/csv-importer#pelias-csv-importer
# expanded <- expanded %>%
#   select(pad_bbl = bbl, houseNum, pad_bin = bin, pad_orig_stname = stname, pad_low = lhnd, pad_high = hhnd, pad_geomtype, stname = alt_st_name, zipcode, lng, lat)
# expanded <- expanded %>%
#   select(bbl, number = houseNum, bin, street = alt_st_name, zipcode, lon = lng, lat, zipcode, addendum_json_pad, name)
  # filter(!is.na(lat) & !is.na(lng)) 
# gc() 

# Checks:
# 1. theoretical unnest count matches actual row count
# 2. check for NAs in crucial columns (stname, lat, lng, bbl)
# "RUNNING CHECKS" %>% print
# checks <- list(
#   missing_lats = expanded %>% filter(is.na(lat)) %>% nrow,
#   missing_lons = expanded %>% filter(is.na(lng)) %>% nrow,
#   missing_bbls = expanded %>% filter(is.na(bbl)) %>% nrow,
#   missing_streets = expanded %>% filter(is.na(alt_st_name)) %>% nrow,
#   missing_zips = expanded %>% filter(is.na(zipcode)) %>% nrow,
#   total_rows = expanded %>% nrow,
#   distinct_rows = expanded %>% distinct %>% nrow
# )
# gc() 
# checks$missing_lats %>% ifelse(., paste("✗ WARNING!", ., "MISSING LATITUDES"), "✓ LATITUDES") %>% print
# checks$missing_lons %>% ifelse(., paste("✗ WARNING!", ., "MISSING LONGITUDES"), "✓ LONGITUDES") %>% print
# checks$missing_bbls %>% ifelse(., paste("✗ WARNING!", ., "MISSING BBLS"), "✓ BBLS") %>% print
# checks$missing_streets %>% ifelse(., paste("✗ WARNING!", ., "MISSING STREETS"), "✓ STREETS") %>% print
# checks$missing_zips %>% ifelse(., paste("✗ WARNING!", ., "MISSING ZIPCODES"), "✓ ZIPCODES") %>% print
# checks$total_rows %>% paste("TOTAL ROWS:", .) %>% print
# checks$distinct_rows %>% paste("DISTINCT ROWS:",.) %>% print

# rm(pad)
# rm(snd)
# gc()

# "SELECTING RELEVANT COLUMNS FOR EXPORT" %>% print
# One last select to pick only columns needed for schema expected by csv-importer

# "WRITING" %>% print
# dir.create(outDir, showWarnings=FALSE)
# dir.create(checksDir, showWarnings=FALSE)
# write_csv(expanded, paste0(outDir, '/labs-geosearch-pad-normalized.csv'), na="")
# gc() 
# write_csv(expanded[sample(nrow(expanded), nrow(expanded) * 0.1), ], paste0(outDir, '/labs-geosearch-pad-normalized-sample-lg.csv'), na="")
# gc() 
# write_csv(expanded[sample(nrow(expanded), nrow(expanded) * 0.05), ], paste0(outDir, '/labs-geosearch-pad-normalized-sample-md.csv'), na="")
# gc() 
# write_csv(expanded[sample(nrow(expanded), nrow(expanded) * 0.01), ], paste0(outDir, '/labs-geosearch-pad-normalized-sample-sm.csv'), na="")
# gc() 
# write(toJSON(checks), paste0(checksDir, '/labs-geosearch-pad-checks-', print(as.integer(Sys.time())*1000, digits=15), '.json'))
# gc()