defmodule Servy.Parser do
  alias Servy.Conv
  def parse(request) do
    # first_line = request |> String.split("\n") |> List.first
    # [method, path, _] = String.split(first_line, " ")
    # %{ method: method, path: path, resp_body: "" }

    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %Conv{
      method: method,
      path: path
    }

    # %{ method: method,
    #    path: path,
    #    resp_body: "",
    #    status: nil
    #  }
  end
end
