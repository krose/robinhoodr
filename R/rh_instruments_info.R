

#' Function to get the fundamentals for the symbols.
#'
#' @param symbols Symbols
#' @export
#' @examples
#'
#' library(robinhood)
#'
#' rh_instruments_info(symbols = c("MSFT", "FB", "GOOG"))
#'
rh_instruments_info <- function(symbols){

  list_rh <- lapply(symbols, function(x)rh_instruments_info_one(symbol = x))

  list_rh <- do.call(rbind, list_rh)

  list_rh
}

rh_instruments_info_one <- function(symbol){

  # Create the url
  rh_url <- rh_base_url()
  rh_url$path <- "instruments/"
  rh_url$query <- list(symbol = paste(symbol, collapse = ","))
  rh_url <- httr::build_url(rh_url)

  # GET the quotes
  quotes_rh <- httr::GET(url = rh_url, httr::user_agent("https://github.com/krose/robinhood"))

  # Check the response
  httr::stop_for_status(quotes_rh)

  # parse the content
  # The unofficial documentation says that the results are paginated,
  # bit I don't see it.
  content_rh <- httr::content(x = quotes_rh, as = "text", encoding = "UTF-8")
  content_rh <- jsonlite::fromJSON(txt = content_rh)
  content_rh <- content_rh$results
  content_rh$list_date <- lubridate::ymd(content_rh$list_date)

  content_rh
}

