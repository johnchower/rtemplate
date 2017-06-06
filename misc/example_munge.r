# This code block only runs if you're in an interactive session.
# It loads up all of the packages and datasets that the script depends on.
# The makefile takes care of this stuff when running in batch mode, but it's 
# useful when developing the script.
if (interactive()){
  # Set the following 3 variables before running:
  projname <- "rtemplate"
  # Cached datasets to use
  to_link_cacheReserve <- list()
  # Raw datasets to use
  to_link_dataReserve <- list("test_data.csv")

  proj_root <- rprojroot::find_root(
    rprojroot::has_dirname(projname)
  )
  setwd(proj_root)

  # Load project packages and helper functions
  ProjectTemplate::load.project()

  # Link datasets into appropriate primary folder
  lA.link_datasets(
    raw_list = to_link_dataReserve
  , cached_list = to_link_cacheReserve
  , proj_root = proj_root
  )

  ProjectTemplate::load.project()

  rm(to_link_dataReserve, to_link_cacheReserve)
}

# Put your code here. It should return a single object, called munge_out

# End of your code 

if (interactive()){
setwd(proj_root)
system("make clean")
}
