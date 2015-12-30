defmodule ScraperTest do
  use ExUnit.Case
  doctest Scraper

  test "format_links_with_domain" do
    url = "http://domain.com"
    links = ["/some/post.atom"]
    assert Scraper.format_links_with_domain(links, url) == ["http://domain.com/some/post.atom"]
  end

  test "format_links_with_domain with https" do
    url = "https://www.domain.com"
    links = ["/some/post.atom"]
    assert Scraper.format_links_with_domain(links, url) == ["https://www.domain.com/some/post.atom"]
  end

  test "adjust domain" do
    domain = "https://domain.com"
    link = "https://domain.com/some/post.atom"
    assert Scraper.adjust_domain(domain, link) == "https://domain.com/some/post.atom"
  end
end
