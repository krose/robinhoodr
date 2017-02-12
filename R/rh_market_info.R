
#' Get the market info for a specific market.
#'
#' @param mic Market identifier code.
#' @export
#'
#' @examples
#'
#' robin_mkt_info <- rh_market_info(mic = "BATS")
rh_market_info <- function(mic){

  # Create the url
  rh_url <- rh_base_url()
  rh_url$path <- paste0("markets/", mic, "/")
  rh_url <- httr::build_url(rh_url)

  # GET the quotes
  quotes_rh <- httr::GET(url = rh_url, httr::user_agent("https://github.com/krose/robinhood"))

  # Check the response
  httr::stop_for_status(quotes_rh)

  # parse the content
  content_rh <- httr::content(x = quotes_rh, as = "text", encoding = "UTF-8")
  content_rh <- jsonlite::fromJSON(txt = content_rh)
  content_rh <- as.data.frame(content_rh, stringsAsFactors = FALSE)

  content_rh
}

