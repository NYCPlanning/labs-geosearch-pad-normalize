# Checks:
# 1. theoretical unnest count matches actual row count
# 2. check for NAs in crucial columns (stname, lat, lng, bbl)
"RUNNING CHECKS" %>% print
checks <- list(
  missing_lats = expanded %>% filter(is.na(lat)) %>% nrow,
  missing_lons = expanded %>% filter(is.na(lng)) %>% nrow,
  missing_bbls = expanded %>% filter(is.na(bbl)) %>% nrow,
  missing_streets = expanded %>% filter(is.na(alt_st_name)) %>% nrow,
  missing_zips = expanded %>% filter(is.na(zipcode)) %>% nrow,
  total_rows = expanded %>% nrow,
  distinct_rows = expanded %>% distinct %>% nrow
)
gc() 
checks$missing_lats %>% ifelse(., paste("✗ WARNING!", ., "MISSING LATITUDES"), "✓ LATITUDES") %>% print
checks$missing_lons %>% ifelse(., paste("✗ WARNING!", ., "MISSING LONGITUDES"), "✓ LONGITUDES") %>% print
checks$missing_bbls %>% ifelse(., paste("✗ WARNING!", ., "MISSING BBLS"), "✓ BBLS") %>% print
checks$missing_streets %>% ifelse(., paste("✗ WARNING!", ., "MISSING STREETS"), "✓ STREETS") %>% print
checks$missing_zips %>% ifelse(., paste("✗ WARNING!", ., "MISSING ZIPCODES"), "✓ ZIPCODES") %>% print
checks$total_rows %>% paste("TOTAL ROWS:", .) %>% print
checks$distinct_rows %>% paste("DISTINCT ROWS:",.) %>% print

gc()