defmodule CurrencyconverterTest do
  use ExUnit.Case
  doctest CurrencyConverter

    test "btc_to_eth" do
      result = CurrencyConverter.convert(100, "bitcoin", "bitcoin")
      ExUnit.Assertions.assert(result === "100.0 BTC",
        "conversion was not as expected : " <> result)
    end

    test "list1" do
      [result] = CurrencyConverter.listAllCoins(1, 0)
      ExUnit.Assertions.assert(String.starts_with?(result, "'Bitcoin' (BTC) -> "),
        "list was not as expected : " <> result)
    end
end
