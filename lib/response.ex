defmodule HttpClient.Response do
  @moduledoc """
  Handles the response of an Http request.
  """

  @doc """
  Extracts the body from the response and returns the publishers json as a map.
  Example return:
  %{"copyCo" =>
    [
      %{
        "publisher" => "News Limited",
        "sourceIDs" => [269062, 42061],
        "url" => "adelaidenow.com.au"
      },
      %{
        "url" => "adzuna.com.au",
        "publisher" => "Fairfax Media",
        "sourceIDs" => []}
    ]
  }
  """
  def decode_response_body(response) do
    regex = ~r/[[:cntrl:]]{2}[^\{]*(?<body>{.*})[[:cntrl:]]*/
    %{"body" => body} = Regex.named_captures(regex, response)

    Poison.decode!(body)
  end


  @doc """
  Receives a publishers map (in the same format returned by decode_response_body)
  and returns another publishers map, excluding all publishers that have a non-empty
  sourceIDs.
  """
  def get_publishers_with_non_empty_sourceIDs(response) do
    Enum.reduce(response, %{}, fn {media, publishers}, acc  ->
      publishers = Enum.filter(publishers, fn pub ->
        pub["sourceIDs"] != []
      end)
      Map.merge(acc, %{media => publishers})
    end)
  end


  @doc """
  Receives a publishers map (in the same format returned by decode_response_body)
  and returns another publishers map, containing only the publishers associated
  to a given sourceID.
  """
  def get_publishers_by_source_ID(response, sourceID) do
    Enum.reduce(response, %{}, fn {media, publishers}, acc  ->
      publishers = Enum.filter(publishers, fn publisher ->
        Enum.any?(publisher["sourceIDs"], & &1 == sourceID)
      end)
      Map.merge(acc, %{media => publishers})
    end)
  end
end
