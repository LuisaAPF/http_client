defmodule HttpClientTest do
  use ExUnit.Case

  describe "The Http client" do
    test "successfully sends an http request" do
      host = "dev-mw-test-service-staging-shakespeare.meltwater.io"
      uri = "/sources/copyco"
      method = "GET"
      headers = ["Accept:", "application/json,application/html", "\r\n"]

      assert {:ok, %{socket: socket} = conn} = HttpClient.connect(host)
      assert :ok = HttpClient.request(conn, method, uri, headers)
      assert {:ok, packet} = HttpClient.response(socket)
      assert packet =~ "HTTP/1.1 200 OK"
    end
  end
end
