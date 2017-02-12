
#' Base url
rh_base_url <- function(){

  httr::parse_url("https://api.robinhood.com")
}
