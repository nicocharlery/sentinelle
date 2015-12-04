defmodule STNL do
  use HTTPoison.Base

  def msg do
    "Hello world from Elixir"
  end

  def get_url(url) do
    HTTPoison.get! url
  end

  def get_body(response) do
    status_code = response.status_code
    case status_code do
      200 ->
       response.body
      301 ->
        location = Enum.filter(response.headers, fn x  -> elem(x,0) == "Location" end)
        location = List.first location
        location = elem(location, 1)
        get_url(location)
        |> get_body
      _ ->
          ''
    end
  end

  def find_links(html) do
    html
    |> Floki.find("a")
    |> Floki.attribute("href")
  end

  def find_feed_links(html) do
   rss = find_rss_links(html)
   atom = find_atom_links(html)
   Enum.concat(rss, atom)
  end

  def find_rss_links(html) do
    html
    |> Floki.find("head")
    |> Floki.find("link[type='application/rss+xml']")
    |> Floki.attribute("href")
  end

  def find_atom_links(html) do
    html
    |> Floki.find("head")
    |> Floki.find("link[type='application/atom+xml']")
    |> Floki.attribute("href")
  end

  def extract_domain_from_url(url) do
    parsed_url = :uri.parse(to_char_list(url))
    case parsed_url do
      {:ok, tuple} ->
        protocol = elem tuple, 0
        authority = elem tuple, 2
        to_string(protocol) <> "://" <> to_string(authority)
      {:error, _} ->
        ""
    end
  end

  def format_links_with_domain(url, links) do
    domain = extract_domain_from_url(url)
    Enum.map(links, fn link -> adjust_domain(domain, link) end)
  end

  def adjust_domain(domain, link) do
    cond do
      String.starts_with?(link, "http") ->
        link
      true ->
        domain <> link
    end
  end

  def process_url(url) do
    links = get_url(url)
    |> get_body
    |> find_feed_links
    format_links_with_domain(url, links)
  end

  def start(_type, _args) do
    #url = "http://niko.bokay.io"
    #url = "http://niko.bokay.io/categories/journal/posts/2015/11/24/premiere-neige"
    #url = "http://david.larlet.fr"
    #url = "http://la-grange.net"
    #url = "https://n.survol.fr/"
    #url = "http://liliedel.tumblr.com/"
    links = process_url(url)
    IO.inspect links

    Supervisor.start_link [], strategy: :one_for_one
  end
end
