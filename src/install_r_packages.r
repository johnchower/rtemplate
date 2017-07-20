packages <- c("devtools", "knitr", "ezknitr", "rprojroot", "ProjectTemplate")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

projname <- "active_user_rankings"
proj_root <- rprojroot::find_root(
  rprojroot::has_dirname(projname)
)
setwd(proj_root)
package_list <- readLines("misc/package_list.r")

strsplit(package_list[19], "/")[[1]][2]
lapply(
  package_list
, FUN = function(name) {
    github_package <- grepl(
      pattern = " github$"
    , x = name
    )
    if (github_package) {
      package_info <- gsub(" github", "", name)
      package_name <- strsplit(package_info, "/")[[1]][2]
    } else {
      package_name <- name
    }
    not_already_installed <- !require(package_name,character.only = TRUE)
    if (not_already_installed){
      if (github_package) {
        devtools::install_github(repo = package_info)
      }
      else {install.packages(name)}
    }
  }
)
