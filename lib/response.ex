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
  Receives a publishers map (in the same form as the return of decode_response_body)
  and returns a list with all publishers that have a non-empty sourceIDs.
  """
  def get_publishers_with_non_empty_sourceIDs(%{"copyCo" => publishers}) do
    Enum.filter(publishers, fn publisher ->
      publisher["sourceIDs"] != []
    end)
  end


  @doc """
  Receives a publishers map (in the same form as the return of decode_response_body)
  and returns a list with all publishers associated to a given sourceID.
  """
  def get_publishers_by_source_ID(%{"copyCo" => publishers}, sourceID) do
    Enum.filter(publishers, fn publisher ->
      Enum.any?(publisher["sourceIDs"], & &1 == sourceID)
    end)
  end
end
