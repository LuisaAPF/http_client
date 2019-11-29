defmodule HttpClient do
  @moduledoc """
  An Http client capable of sending https requests to a host via ssl.
  """

  @doc """
  Returns {:ok, %{socket: socket, host: hostname}} or {:error, reason}
  """
  def connect(hostname) do
    port = 443
    transport_options = [active: false, packet: :raw, mode: :binary]

    case :ssl.connect(String.to_charlist(hostname), port, transport_options) do
      {:ok, socket} ->
        conn = %{socket: socket, host: hostname}
        {:ok, conn}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Returns :ok or {:error, reason}
  """
  def request(conn, method, uri, headers \\ [], body \\ "") do
    %{socket: socket, host: hostname} = conn
    headers = put_required_headers(hostname) ++ headers

    payload = [
      method,
      " ",
      uri,
      " HTTP/1.1\r\n",
      headers,
      "\r\n",
      body,
      "\r\n\r\n"
    ]

    :ssl.send(socket, payload)
  end

  defp put_required_headers(hostname) do
    ["Host:", hostname, "\r\n"]
  end

  @doc """
  Returns {:ok, response} or {:error, reason}
  """
  def response(socket) do
    :ssl.recv(socket, 0)
  end
end
