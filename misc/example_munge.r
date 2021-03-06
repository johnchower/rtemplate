# This code block only runs if you're in an interactive session.
# It loads up all of the packages and datasets that the script depends on.
# The makefile takes care of this stuff when running in batch mode, but it's 
# useful when developing the script.
if (interactive()){
# Set the following 3 variables before running: a
projname <- "rtemplate"
# Cached datasets to use
# Enter full name of dataset, without path
# For example, m0.advanced_invites_sent.RData
to_link_cacheReserve <- list(
)
# Raw datasets to use
# Enter full name of dataset, without path
# For example, advanced_invites_sent.csv
to_link_dataReserve <- list(
)
# Find the project's root directory
proj_root <- rprojroot::find_root(
  rprojroot::has_dirname(projname)
)
# Clean out existing symlinks in directory
system(paste0(
  "cd "
, gsub(proj_root, pattern = " ", replacement = "\\\\ ")
, " ; "
, "make clean"
))
# Load project packages and functions
setwd(proj_root)
suppressMessages(ProjectTemplate::load.project())
# Link datasets into appropriate primary folder
lA.link_datasets(
  raw_list = to_link_dataReserve
, cached_list = to_link_cacheReserve
, proj_root = proj_root
)
# Load project data
suppressMessages(ProjectTemplate::load.project())
# Clean up
rm(to_link_dataReserve, to_link_cacheReserve)
system(paste0(
  "cd "
, gsub(proj_root, pattern = " ", replacement = "\\\\ ")
, " ; "
, "make clean"
))
}

# Put your code below. It should return a single object, called munge_out
