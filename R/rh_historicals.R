#' Get the historical quotes for a symbol.
#'
#' @param symbol The shorthand symbols.
#' @param interval The interval: week|day|10minute|5minute
#' @param span The span: day|week|year
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
#' rh_historicals(symbol = symbol, interval = "5minute", span = "week", bounds = "regular")
#' rh_historicals(symbol = symbol, interval = "10minute", span = "day", bounds = "regular")
#' rh_historicals(symbol = symbol, span = "year", to_xts = TRUE)
#' rh_historicals(symbol = symbol, span = "", to_xts = TRUE)
#' rh_historicals(symbol = symbol, to_xts = TRUE)
rh_historicals <- function(symbols, interval = "day",
                           span = "year", bounds = "regular",
                           keep_meta = FALSE, to_xts = FALSE){

  # Get the data
  hist_list <- lapply(X = symbols,
                      function(x){rh_historicals_one(symbol = x,
                                                     interval = interval,
                                                     span = span,
                                                     bounds = bounds)})

  # Keep only the historical data
  if(!keep_meta){
    hist_list <- lapply(hist_list, function(x) x$historicals[[1]])
  }

  if(to_xts & !keep_meta){

    hist_list <- lapply(hist_list,
                        function(x){
                          x_converted <- xts::xts(x = x[, c("open_price", "close_price", "high_price", "low_price", "volume")],
                                                  order.by = x$begins_at)
                          attr(x_converted, "session") <- x$session
                          attr(x_converted, "interpolated") <- x$interpolated

                          x_converted
                        })
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

  # Check the responce
  if (httr::http_error(quotes_rh)) {
    stop(
      httr::content(x = quotes_rh, as = "text", encoding = "UTF-8"),
      call. = FALSE)
  }

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
