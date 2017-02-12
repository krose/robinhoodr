#' Get a quote for one or more symbols.
#'
#' @param symbols The shorthand symbols.
#' @export
#' @examples
#'
#' library(robinhood)
#'
#' symbols <- c("MSFT", "FB", "TSLA")
#'
#' rh_quote(symbols = symbols)
rh_quote <- function(symbols){

  # Create the url
  rh_url <- rh_base_url()
  rh_url$path <- "quotes/"
  rh_url$query <- list(symbols = paste(symbols, collapse = ","))
  rh_url <- httr::build_url(rh_url)

  # GET the quotes
  quotes_rh <- httr::GET(url = rh_url, httr::user_agent("https://github.com/krose/robinhood"))

  # Check the response
  httr::stop_for_status(quotes_rh)

  # parse the content
  content_rh <- httr::content(x = quotes_rh, as = "text", encoding = "UTF-8")
  content_rh <- jsonlite::fromJSON(txt = content_rh)
  content_rh <- content_rh$results

  # Format the the datetimes.
  content_rh$previous_close_date <- lubridate::ymd(content_rh$previous_close_date,
                                                   tz = "UTC")

  content_rh$updated_at <- lubridate::ymd_hms(content_rh$updated_at,
                                    tz = "UTC")

  content_rh
}

