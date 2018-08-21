defmodule Servy.Handler do
  def handle(request) do
    # conv = parse(request)
    # conv = route(conv)
    # format_response(conv)
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def log(conv), do: IO.inspect conv


  def parse(request) do
    # first_line = request |> String.split("\n") |> List.first
    # [method, path, _] = String.split(first_line, " ")
    # %{ method: method, path: path, resp_body: "" }

    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method, path: path, resp_body: "" }
  end

  def route(conv) do
    if conv.path == "/wildthings" do
      # same as Map.put(conv, :resp_body,"Bears, Lions, Tigers" )
      %{ conv | resp_body: "Bears, Lions, Tigers" }
    else
      %{ conv | resp_body: "Teddy, Smokey, Paddington" }
    end
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

end

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


response = Servy.Handler.handle(request)

IO.puts response
