defmodule Servy.Handler do
  alias Servy.Conv
  @moduledoc """
  Handles Http requests
  """
  @pages_path  Path.expand("../../pages", __DIR__)

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  @doc """
  Transforms the request into a response
  """
  def handle(request) do
    # conv = parse(request)
    # conv = route(conv)
    # format_response(conv)
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  @doc """
   Logs 404 requests
  """



  def route(%{method: "GET", path: "/wildthings"} = conv) do
    # same as Map.put(conv, :resp_body,"Bears, Lions, Tigers" )
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(%{ method: "GET", path: "/about"} = conv) do
    file =
      @pages_path
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
    # case File.read(file) do
    #   {:ok, content} ->
    #     %{ conv | status: 200, resp_body: content }

    #   {:error, enoent } ->
    #     %{ conv | status: 400, resp_body: "File not found " }

    #   {:error, reason } ->
    #     %{ conv | status: 500, resp_body: "File error: #{reason} " }
    # end
  end

  def handle_file({:ok, content}, conv) do
    %{ conv | status: 200, resp_body: content }
  end

  def handle_file({:error, enoent }, conv) do
    %{ conv | status: 400, resp_body: "File not found " }
  end

  def handle_file({:error, reason }, conv) do
    %{ conv | status: 500, resp_body: "File error: #{reason} " }
  end
  def route(%Conv{ path: path} = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end


end


request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response
