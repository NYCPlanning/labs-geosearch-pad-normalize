args <- commandArgs(trailingOnly=TRUE)
defaultPadVersion <- "19a"
if(length(args) == 0) {
  print(paste("No PAD version specified. Using default", defaultPadVersion))
  padVersion <- defaultPadVersion
} else{
  padVersion <- args[1]
  print(paste("Using PAD version: ", padVersion))
}

dataDir <- "./data"
outDir <-"/data/nycpad"
