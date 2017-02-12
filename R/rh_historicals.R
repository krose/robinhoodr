#' Get the historical quotes for a symbol.
#'
#' @param symbol The shorthand symbols.
#' @param interval The interval: week|day|10minute|5minute|null(all)
#' @param span day|week|year|5year|all
#' @param bounds extended|regular|trading
#' @export
#' @examples
#'
#' library(robinhoodr)
#'
#' symbol <- c("MSFT")
#'
#' rh_historicals(symbol = symbol) # Get the last years closing prices.
#' rh_historicals(symbol = symbol, interval = "5minute", span = "day", bounds = "trading")
#' rh_historicals(symbol = symbol, interval = "5minute", span = "day", bounds = "extended")
#' rh_historicals(symbol = symbol, interval = "5minute", span = "day", bounds = "regular")
rh_historicals <- function(symbols, interval = "day", span = "year", bounds = "regular", keep_meta = FALSE){

  # Get the data
  hist_list <- lapply(X = symbols,
                      function(x){rh_historicals_one(symbol = x,
                                                     interval = interval,
                                                     span = span,
                                                     bounds = bounds)})

  # Keep only the historical data
  if(!keep_meta){
    hist_list <- lapply(hist_list, function(x)x$historicals)
  }

  # name the list.
  names(hist_list) <- symbols

  hist_list
}


rh_historicals_one <- function(symbol, interval = interval, span = span, bounds = bounds){

  # Create the url
  rh_url <- rh_base_url()
  rh_url$path <- paste0("quotes/historicals/", symbol, "/")
  rh_url$query <- list(interval = interval,
                       span = span,
                       bounds = bounds)
  rh_url <- httr::build_url(rh_url)

  # GET the quotes
  quotes_rh <- httr::GET(url = rh_url)

  # Check the response
  httr::stop_for_status(quotes_rh)

  # parse the content
  content_rh <- httr::content(x = quotes_rh, as = "text", encoding = "UTF-8")
  content_rh <- jsonlite::fromJSON(txt = content_rh)

  meta_rh <- as.data.frame(content_rh[1:6], stringsAsFactors = FALSE)

  hist_rh <- content_rh$historicals
  hist_rh$begins_at <- lubridate::ymd_hms(hist_rh$begins_at,
                                          tz = "UTC")
  hist_rh$open_price <- as.numeric(hist_rh$open_price)
  hist_rh$close_price <- as.numeric(hist_rh$close_price)
  hist_rh$high_price <- as.numeric(hist_rh$high_price)
  hist_rh$low_price <- as.numeric(hist_rh$low_price)

  meta_rh$historicals <- list(hist_rh)

  meta_rh
}
