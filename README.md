# Currency Converter

A very simple cryptocurrency conversion calculator.

Uses the CoinMarketCap.com API to get info for the currencies
Converts the amount to dollars, and then converts it to the target currency

If currency is Bitcoin, the API call would be:
https://api.coinmarketcap.com/v1/ticker/bitcoin/

> convert: currencyconverter --amount <amount> --from <from> --to <to>

> example: currencyconverter --amount 10000 --from bitcoin --to ethereum

> list all coins : currencyconverter --listAll

# Setup

1) Install Erlang and Elexir
2) in the main directory run *"mix deps.get"* to get all dependencies
3) in the main directory run *"mix escript.build"* to build as a console application
4) in the main directory run *"escript currencyconverter <args>"* to run
