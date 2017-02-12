
#' Function to get the split info on a symbol.
#'
#' @param symbols Symbols.
#' @export
#' @examples
#'
#' library(robinhoodr)
#'
#' rh_instruments_split(c("MSFT", "JDST", "FB"))
rh_instruments_split <- function(symbols){

  list_rh <- rh_instruments_info(symbols = symbols)

  list_rh <- list_rh[, c("symbol", "splits")]

  list_rh <- lapply(list_rh$splits, split_helper)

  names(list_rh) <- symbols

  list_rh
}

split_helper <- function(split_url){

  get_hr <- httr::GET(url = split_url,
                      httr::add_headers("https://github.com/krose/robinhood"))

  httr::stop_for_status(get_hr)

  content_hr <- httr::content(get_hr, as = "text", encoding = "UTF-8")
  content_hr <- jsonlite::fromJSON(content_hr)
  content_hr <- content_hr$results

  if(length(content_hr) > 0){
    content_hr <- as.data.frame(content_hr, stringsAsFactors = FALSE)

    content_hr$execution_date <- lubridate::ymd(content_hr$execution_date,
                                                tz = "UTC")

  }

  content_hr
}
