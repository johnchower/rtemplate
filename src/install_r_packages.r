packages <- c("devtools", "knitr", "ezknitr", "rprojroot", "ProjectTemplate")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

projname <- "rtemplate"
proj_root <- rprojroot::find_root(
  rprojroot::has_dirname(projname)
)
setwd(proj_root)
package_list <- readLines("misc/package_list.r")

lapply(
  package_list
, FUN = function(name) {
    already_installed <- !require(name,character.only = TRUE)
    if (already_installed){
      github_package <- grepl(
        pattern = " github$"
      , x = name
      )
      if (github_package) {
        package_info <- gsub(" github", "", name)
        print(package_info)
        devtools::install_github(repo = )
      }
      else {install.packages(name)}
    }
  }
)
