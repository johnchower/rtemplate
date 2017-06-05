if (!interactive()){
  option_list <- list(
    optparse::make_option(
      "--markdownpath"
    , type = "character"
    , default = "rtemplate"
    , help = "Path to input rmarkdown file, with .Rmd extension, relative to
        project root directory."
    )
  , optparse::make_option(
      "--projname"
    , type = "character"
    , default = "rtemplate"
    , help = "Name of root directory of project"
    )
  )
  opt <- optparse::parse_args(optparse::OptionParser(option_list = option_list))
  projname <- opt$projname
  markdownpath <- opt$markdownpath
} else {
  projname <- "rtemplate"
  markdownpath <- "src/report.Rmd"
}

proj_root <- rprojroot::find_root(
  rprojroot::has_dirname(projname)
)

setwd(proj_root)

ProjectTemplate::load.project()
library(stringr)

reportname <- markdownpath %>%
  str_replace(pattern = ".Rmd", replacement = "") %>%
  str_split(pattern = "/") %>%
  unlist %>%
  tail(1)

library(ezknitr)

ezknitr::ezknit(
  file = markdownpath
, wd = proj_root
, out_dir = "reports"
, fig_dir = paste0("figs_", reportname) 
, keep_md = FALSE
)
