ProjectTemplate::load.project(
  override.config = list(
    munging = F
  , data_loading = F
  , cache_loading = F
  , load_libraries = T
  )
)

if (!interactive()){
  option_list <- list(
    optparse::make_option(
      "--auth_file_location"
    , type = "character"
    , default = ""
    , help = "Path to auth file containing database credentials"
    )
  , optparse::make_option(
      "--dbname"
    , type = "character"
    , default = "insightsbeta"
    , help = "Name of database to run query against.
        Currently supports 'insightsbeta' and 'polymer_production'"
    )
  , optparse::make_option(
      "--projname"
    , type = "character"
    , default = "rtemplate"
    , help = "Name of root directory of project"
    )
  )
  opt <- optparse::parse_args(optparse::OptionParser(option_list = option_list))

  auth_file_location <- opt$auth_file_location
  projname <- opt$projname
  dbname <- opt$dbname
} else {
  auth_file_location <- "~/.auth/authenticate.csv"
  projname <- "rtemplate"
  dbname <- "testDB"
}

proj_root <- rprojroot::find_root(
  rprojroot::has_dirname(projname)
)

csv_directory <- paste0(
  proj_root
  , "/"
  , "dataReserve"
  , "/"
)
query_directory <- paste0(
  proj_root
  , "/"
  , "queries"
  , "/"
)

auth <- read.csv(auth_file_location, stringsAsFactors = F)

if (!(dbname %in% auth$dbname)){
  stop(paste0(
    "Supplied dbname doesn't exist in "
  , auth_file_location
  ))
} else {
  auth <- unlist( auth[auth$dbname == dbname,] )
}

if (auth[["type"]] == "SQLite"){
  library(RSQLite)
  db_connection <- list(
    con = RSQLite::dbConnect(
      drv = RSQLite::SQLite()
    , auth[["location"]]
    )
  , drv = RSQLite::SQLite()
  )
} else if (auth[["type"]] == "PostgreSQL"){
  library(RPostgreSQL)
  db_connection <- list(
    con = RPostgreSQL::dbConnect(
      drv = DBI::dbDriver("PostgreSQL")
    , dbname = auth[["dbname"]]
    , host = auth[["host"]]
    , port = auth[["port"]]
    , user = auth[["user"]]
    , password = auth[["password"]]
    )
  , drv = DBI::dbDriver("PostgreSQL")
  )
}

query_list <- query_directory %>% {
  paste0(., dir(.))
} %>%
lapply(
  FUN = function(x) gsub(
    pattern = ";"
  , replacement = ""
  , paste(readLines(x), collapse = " ")
  )
)

query_list_names <- dir(query_directory) %>% {
        gsub(pattern = ".sql", replacement = "", x = .)
    }

result_list <- lapply(
  query_list
, function(q) dbGetQuery(
    conn = db_connection$con
  , statement = q
  )
)
names(result_list) <- query_list_names

result_list %>%
  names %>%
  lapply(function(name) {
    result_df <- result_list[[name]]
    out_file <- paste0(csv_directory, name, ".csv")
    write.csv(
      result_df
    , file = out_file
    , row.names = F
    )
  })
