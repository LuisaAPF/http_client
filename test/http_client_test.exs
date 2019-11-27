defmodule HttpClientTest do
  use ExUnit.Case
  doctest HttpClient

  test "greets the world" do
    assert HttpClient.hello() == :world
  end
end
