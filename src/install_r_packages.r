projname <- "active_user_rankings"
proj_root <- rprojroot::find_root(
  rprojroot::has_dirname(projname)
)
setwd(proj_root)
package_list <- readLines("misc/package_list.r")
install.packages(package_list)
