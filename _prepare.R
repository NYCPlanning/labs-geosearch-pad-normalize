# Add JSON-formatted string column for csv-import "addendum" with bbl and bin and
# add name and source fields expected by csv-importer
# https://github.com/pelias/csv-importer#custom-data
"ADDING CSV-IMPORTER COLUMNS" %>% print
expanded <- expanded %>% 
  mutate(addendum_json_pad = paste('{"bbl":"', bbl, '","bin":"',bin,'"}', sep = "")) %>%
  mutate(
    name = case_when(
      is.na(houseNum) ~ alt_st_name,
      TRUE            ~ paste(houseNum, alt_st_name, sep=" ")
    )
  ) %>%
  mutate(source = "nycpad")

"RENAMING AND SELECTING COLUMNS FOR CSV-IMPORTER" %>% print
expanded <- expanded %>%
  select(name, source, number = houseNum, street = alt_st_name, zipcode, lon = lng, lat, zipcode, addendum_json_pad)