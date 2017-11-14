defmodule CurrencyConverter do
  @moduledoc """
  Documentation for Currencyconverter.
  """

  def main(args) do
    parse_args(args)
      |> process
  end

  defp parse_args(args) do
    parsed = OptionParser.parse(args, #["--amount", "10000", "--from", "bitcoin", "--to", "ethereum"],
      switches: [
        help: :boolean,
        amount: :float,
        from: :string,
        to: :string,
        list: :boolean,
        listLimit: :integer,
        listStart: :integer
        ],
      aliases: [h: :help])

    IO.inspect parsed

    case parsed do

      {[amount: amount, from: from, to: to], _, _}
        -> [:convert, amount, from, to]
      {[help: true], _, _}
        -> :help
      {[listAll: true, listLimit: listLimit, listStart: listStart], _, _}
        -> [:list, listLimit, listStart]
      {[list: true, listLimit: listLimit], _, _}
        -> [:list, listLimit, 0]
      {[list: true], _, _}
        -> [:list, 100, 0]
      _ -> []
    end
  end

  def process([]) do
    IO.puts "No arguments given"
    process(:help)
  end

  def process(:help) do
    IO.puts """

    Currency Converter
    ------------
    To Convert:
    usage: currencyconverter --amount <amount> --from <from> --to <to>
    example: currencyconverter --amount 10000 --from bitcoin --to ethereum
      (displays the number after conversion + the symbol of the currency, like "200200.04721235269 ETH")

    To List:
    usage: currencyconverter --list --listLimit <default=100> --listStart <default=0>
    example1: currencyconverter --list
      (display the first 100 coins)
    example2: currencyconverter --list --listLimit 50
      (display the first 50 coins)
    example3: currencyconverter --list --listLimit 50 --listStart 2
      (this will display the coins between positions 2 and 52)
    """
  end

  def process([:list, listLimit, listStart]) do
    Enum.each(listAllCoins(listLimit, listStart), fn coin -> IO.puts coin end)
  end

  def process([:convert, amount, from, to]) do
    IO.puts convert(amount, from, to)
  end


  @doc """
  Uses the CoinMarketCap API to get info for the currencies
  Converts the amount to dollars, and then converts it to the target currency

  If currency is Bitcoin, the API call would be:
  https://api.coinmarketcap.com/v1/ticker/bitcoin/
  """
  def convert(amount, fromCurrency, toCurrency) do
    [responseFrom] = HTTPoison.get!("https://api.coinmarketcap.com/v1/ticker/" <> fromCurrency <> "/").body
      |> Poison.decode!
    [responseTo] = HTTPoison.get!("https://api.coinmarketcap.com/v1/ticker/" <> toCurrency <> "/").body
      |> Poison.decode!

    {from_price_usd, _} = Float.parse responseFrom["price_usd"]
    {to_price_usd, _} = Float.parse responseTo["price_usd"]
    result = (from_price_usd * amount) / to_price_usd
    "#{result} #{responseTo["symbol"]}"
  end

  @doc """
  Uses the CoinMarketCap API to get info for the currencies
  Lists currencies info, ordered by market cap

  API example : https://api.coinmarketcap.com/v1/ticker/?start=0&limit=10
  """
  def listAllCoins(listLimit, listStart) do
    responseFrom = HTTPoison.get!("https://api.coinmarketcap.com/v1/ticker/?start=#{listStart}&limit=#{listLimit}").body
      |> Poison.decode!
      Enum.map(responseFrom, fn coin -> "'#{coin["name"]}' (#{coin["symbol"]}) -> $ #{coin["price_usd"]}." end)
  end
end
