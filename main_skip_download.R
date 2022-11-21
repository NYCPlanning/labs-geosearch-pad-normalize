# This file does the exact same thing as main.R except it skips running _download_data.R.
# This is just for convenience for developmeent! This file should never be run in production!
source('_globals.R')
source('_dependencies.R')
source('_functions.R')
source('_load_data.R')
source('_clean.R')
source('_filter.R')
source('_classify.R')
source('_sequence.R')
source('_expand.R')
source('_check.R')
source('_prepare.R')
source('_write.R')