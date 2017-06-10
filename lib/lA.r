# Link cached and raw datasets into the proper places for a munge script
# @param raw_list List of raw datasets to link
# @param cached_list List of cached datasets to link
# @param ... Additional arguments to pass to lA.link_datasets0
lA.link_datasets <- function(
  raw_list = list()
, cached_list = list()
, ...
){
  lA.link_datasets0(
    cached_list
  , "cache"
  , "cacheReserve"
  , ...
  )
  lA.link_datasets0(
    raw_list
  , "data"
  , "dataReserve"
  , ...
  )
}

# Link a collection of datasets from a Reserve folder into a primary folder
# @param name_list List of names of datasets to link
# @param target_dir The directory where symlinks land (path relative to project
# root)
# @param source_dir The directory where symlinks originate (path relative 
# to project root)
# @param proj_root Full path to the projects root directory
# TODO: This only works if the source and target directory are at the
# top-level. Work it out so that they can be anywhere underneath the project
# root.
lA.link_datasets0 <- function(
  name_list = list()
, target_dir
, source_dir
, proj_root
){
  proj_root <- paste0("'", proj_root, "'")
  if (length(name_list > 0)){
    # Link datasets
    name_list %>%
      map(function(name){
        system(paste0(
          "cd ", proj_root, "/", target_dir, " ; "
        , "ln -s ../", source_dir, "/", name
        ))
      })
  } else {
    cat(paste0("No datasets to link in ", source_dir))
  }
}
