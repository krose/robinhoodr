#' Get a big list of all the instruments.
#'
#' @export
#' @examples
#'
#' robin_inst <- rh_instruments()
#'
rh_instruments <- function(){

  # Create the url
  rh_url <- rh_base_url()
  rh_url$path <- "instruments/"
  rh_url <- httr::build_url(rh_url)

  # Get all of the available markets
  has_next <- rh_url
  page <- 1
  content_rh <- list()
  while(!is.null(has_next)){

    # GET the quotes
    quotes_rh <- httr::GET(url = has_next, httr::user_agent("https://github.com/krose/robinhood"))

    # Check the response
    httr::stop_for_status(quotes_rh)

    # parse the content
    content_rh[[page]] <- httr::content(x = quotes_rh, as = "text", encoding = "UTF-8")
    content_rh[[page]] <- jsonlite::fromJSON(txt = content_rh[[page]])

    has_next <- content_rh[[page]]$`next`

    content_rh[[page]] <- content_rh[[page]]$results
    page <- page + 1
  }

  content_rh <- do.call(rbind, content_rh)
  content_rh$margin_initial_ratio <- as.numeric(content_rh$margin_initial_ratio)
  content_rh$day_trade_ratio <- as.numeric(content_rh$day_trade_ratio)
  content_rh$maintenance_ratio <- as.numeric(content_rh$maintenance_ratio)
  content_rh$list_date <- lubridate::ymd(content_rh$list_date, tz = "UTC")

  content_rh
}

