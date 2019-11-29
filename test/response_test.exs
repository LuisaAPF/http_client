defmodule HttpClient.ResponseTest do
  use ExUnit.Case

  alias HttpClient.Response

  describe "decode_response_body/1" do
    test "returns the response body as a map" do

      response = ~s"""
      HTTP/1.1 200 OK
      Content-Type: text/plain; charset=utf-8
      Server: nginx/1.15.3

      something
      {"copyCo":[{"url":"adelaidenow.com.au","publisher":"News Limited","sourceIDs":[269062,42061]}]}
      something else

      """

      assert %{"copyCo" =>
                [
                  %{
                    "publisher" => "News Limited",
                    "sourceIDs" => [269062, 42061],
                    "url" => "adelaidenow.com.au"
                  }
                ]
              } = Response.decode_response_body(response)
    end
  end

  describe "get_publishers_with_non_empty_sourceIDs/1" do
    test "returns a list with all publishers that have a non-empty sourceIDs" do
      json_response =
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

      assert [
        %{
          "publisher" => "News Limited",
          "sourceIDs" => [269062, 42061],
          "url" => "adelaidenow.com.au"
        }
      ] == Response.get_publishers_with_non_empty_sourceIDs(json_response)
    end
  end

  describe "get_publishers_by_source_ID" do
    test "returns a list with all publishers associated to a given sourceID" do
      json_response =
        %{"copyCo" =>
          [
            %{
              "url" => "adelaidenow.com.au",
              "publisher" => "News Limited",
              "sourceIDs" => [3, 8]
            },
            %{
              "url" => "adzuna.com.au",
              "publisher" => "Fairfax Media",
              "sourceIDs" => [1, 5, 9]
            },
            %{
              "url" => "afr.com",
              "publisher" => "Fairfax Media",
              "sourceIDs" => [2, 3, 4]
            }
          ]
        }

        assert [
          %{
            "url" => "adelaidenow.com.au",
            "publisher" => "News Limited",
            "sourceIDs" => [3, 8]
          },
          %{
            "url" => "afr.com",
            "publisher" => "Fairfax Media",
            "sourceIDs" => [2, 3, 4]
          }
        ] |> Enum.sort_by(& &1["url"]) == Response.get_publishers_by_source_ID(json_response, 3) |> Enum.sort_by(& &1["url"])
    end
  end
end
