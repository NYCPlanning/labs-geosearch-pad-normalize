"SEQUENCING" %>% print
# This step creates a new column, `houseNums`, which is either NA or a comma-separated list of value(s). 
# Based on the rowType above, it will delegate a particular row in the iteration to a specific function
# that constructs the comma-sparated list. This list is not a true R list, but a simple character with commas and values. 

# comma-separated list of houseNums is exploded and iterated over to create expanded data set, with one row for each house number

# garbage collection
gc()


pad <- pad %>%
  mutate(
    houseNums = apply(
      pad,
      1,
      delegate
    )
  )
