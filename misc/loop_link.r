ProjectTemplate::load.project(
  override.config = list(
    munging = F
  , data_loading = F
  , cache_loading = F
  , load_libraries = T
  )
)
library(stringr)

if (!interactive()){
  option_list <- list(
    optparse::make_option(
      "--projname"
    , type = "character"
    , default = ""
    , help = "Name of project's top-level directory"
    )
  , optparse::make_option(
      "--sourcedir"
    , type = "character"
    , default = ""
    , help = "Relative path to directory containing link sources"
    )
  , optparse::make_option(
      "--targetdir"
    , type = "character"
    , default = ""
    , help = "Relative path to directory containing link targets"
    )
  , optparse::make_option(
      "--filenames"
    , type = "character"
    , default = ""
    , help = "Names of files within sourcedir to link"
    )
  )
  opt <- optparse::parse_args(optparse::OptionParser(option_list = option_list))

  projname <- opt$projname
  targetdir <- opt$targetdir
  sourcedir <- opt$sourcedir
  filenames <- opt$filenames
} else {
  library(dplyr)
  projname <- "invitation_effectiveness"
  targetdir <- "data"
  sourcedir <- "dataReserve"
  filenames <- "dataReserve/file1.csv dataReserve/file3.csv"
}

proj_root <- rprojroot::find_root(
  rprojroot::has_dirname(projname)
)

targetdir <- paste0(
  "'"
, proj_root
, "/"
, targetdir
, "'"
)
sourcedir <- paste0(
  "'"
, proj_root
, "/"
, sourcedir
, "'"
)

# Relative path to source directory from target directory
target_to_source <- system(
  command = paste0(
    "realpath --relative-to="
  , targetdir
  , " "
  , sourcedir
  )
, intern = T
)

# Get just the names of the files, no paths
target_to_file <- strsplit(filenames, split = " ")[[1]] %>%
  strsplit(split = "/") %>%
  lapply(function(x) {
    paste0(
      target_to_source
    , "/"
    , x[[2]]
    )
  }) %>%
  unlist

for (i in 1:length(target_to_file)){
  target_path <- target_to_file[i]
  system(command = paste0(
    "cd "
  , targetdir
  , " ; "
  , "ln -s "
  , target_path
  ))
}
