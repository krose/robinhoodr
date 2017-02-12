
<!-- README.md is generated from README.Rmd. Please edit that file -->
robinhood
=========

[Robinhood](https://robinhood.com/company/) is here to democratize access to the financial markets. This is an R package to help with that.

This package is made based on the [unofficial documentation](https://github.com/sanko/Robinhood/) so it might have a few rough edges.

I have only implemented the parts of the API where authentication isn't needed, since I can't open an account. Please feel free to add the missing functionality.

### Current functionality

-   Get the last quote: (`rh_quote`)
-   Historical quotes: (`rh_historicals`)
-   Meta info on markets: (`rh_markets`)
-   Get the market hours for a specific market: (`rh_market_hours`)
-   Get all the instruments (the api returns paginated results, so it might take a while to download): (`rh_instruments`)
-   Instruments fundamentals: (`rh_instruments_info`)
-   Instruments splits: (`rh_instruments_split`)
-   instruments keyword search: (`rh_instruments_search`)

### Related Projects

-   [Python](https://github.com/MeheLLC/Robinhood)
-   [npmjs](https://www.npmjs.com/package/robinhood)
-   [chris Busse Notes](http://chrisbusse.com/research/robinhood-brokerage-api-notes.html)
