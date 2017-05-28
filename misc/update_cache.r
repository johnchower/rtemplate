option_list <- list(
  optparse::make_option(
    "--cache_loading"
  , type = "logical"
  , default = T
  , help = "load project cache?"  
  )
, optparse::make_option(
    "--munging"
  , type = "logical"
  , default = T
  , help = "run munging scripts?"
  )
, optparse::make_option(
    "--outname"
  , type = "character"
  , default = "cached_data"
  , help = "The name of the file (without extension) to cache"
  )
)
opt <- optparse::parse_args(optparse::OptionParser(option_list = option_list))

ProjectTemplate::load.project(
  override.config = list (
    munging = opt$munging
  , cache_loading = opt$cache_loading
  )
)

ProjectTemplate::cache(opt$outname)
