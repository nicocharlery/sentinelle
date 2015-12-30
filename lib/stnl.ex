defmodule STNL do
  def start(_type, _args) do
    url = "http://niko.bokay.io"
    feeds = Scraper.process_url(url)
    IO.inspect feeds

    Supervisor.start_link [], strategy: :one_for_one
  end
end
