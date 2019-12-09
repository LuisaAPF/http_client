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
    test "returns a map with all publishers that have non-empty sourceIDs" do
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
          ],
          "fairFax" => [
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

      assert %{
        "copyCo" => [%{
          "publisher" => "News Limited",
          "sourceIDs" => [269062, 42061],
          "url" => "adelaidenow.com.au"
        }],
        "fairFax" => [%{
          "publisher" => "News Limited",
          "sourceIDs" => [269062, 42061],
          "url" => "adelaidenow.com.au"
        }]
      } == Response.get_publishers_with_non_empty_sourceIDs(json_response)
    end
  end

  describe "get_publishers_by_source_ID" do
    test "returns a map with all publishers associated to a given sourceID" do
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
          ],
          "fairFax" => [
            %{
              "url" => "adelaidenow.com.au",
              "publisher" => "News Limited",
              "sourceIDs" => [6]
            },
            %{
              "url" => "adzuna.com.au",
              "publisher" => "Fairfax Media",
              "sourceIDs" => [3, 5, 9]
            },
          ]
        }

        assert %{
          "copyCo" => [
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
          ],
          "fairFax" => [
            %{
              "url" => "adzuna.com.au",
              "publisher" => "Fairfax Media",
              "sourceIDs" => [3, 5, 9]
            }
          ]
        } == Response.get_publishers_by_source_ID(json_response, 3)
    end
  end
end
