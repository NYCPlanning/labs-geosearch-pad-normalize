"CHECKING EXPANSION COLUMN FOR NON-NULL/NON-NA TYPES: " %>% print
# For debugging, check if there were any rows that were missed in the iteration. 
pad %>% distinct(typeof(houseNums)) %>% print

"EXPANDING" %>% print
# Filter out rows with missing lat or long values
expanded <- pad %>%
  filter(!is.na(lat) & !is.na(lng))

unnest <- unnest_legacy
expanded <- expanded %>% 
  mutate(houseNum = strsplit(houseNums, ',')) %>%
  unnest(houseNum) %>% 
  mutate(lgc = strsplit(gsub("(.{2})", "\\1,", validlgcs), ',')) %>% 
  unnest(lgc) %>%
  inner_join(snd, by=c('boro', 'sc5', 'lgc'))

# Debugging messages about type distribution
pad %>% group_by(rowType) %>% summarise(count = length(rowType)) %>% print
expanded %>% group_by(rowType) %>% summarise(count = length(rowType)) %>% print
rm(pad)
rm(snd)
gc() 