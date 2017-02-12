#' Instrument keyword search.
#'
#' This function lets you search for a keyword
#' that fx might be found in the name.
#'
#' @param keyword Keyword to search for.
#' @export
#' @examples
#'
#' library(robinhood)
#'
#' rh_instrument_search(keyword = "oil")
rh_instruments_search <- function(keyword){

  # Create the url
  rh_url <- rh_base_url()
  rh_url$path <- "instruments/"
  rh_url$query <- list(query = keyword)
  rh_url <- httr::build_url(rh_url)

  # GET the search result
  quotes_rh <- httr::GET(url = rh_url, httr::user_agent("https://github.com/krose/robinhood"))

  # Check the response
  httr::stop_for_status(quotes_rh)

  # parse the content
  content_rh <- httr::content(x = quotes_rh, as = "text", encoding = "UTF-8")
  content_rh <- jsonlite::fromJSON(txt = content_rh)
  content_rh <- content_rh$results

  content_rh

}
