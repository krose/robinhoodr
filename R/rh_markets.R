

#' Returns a data.frame with all the available markets.
#'
#' @export
rh_markets <- function(){

  # Create the url
  rh_url <- rh_base_url()
  rh_url$path <- "markets/"
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

  # rbind all the lists
  content_rh <- do.call(rbind, content_rh)

  content_rh
}
