defmodule STNLTest do
  use ExUnit.Case
  doctest STNL

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "print message" do
    assert STNL.msg() == "Hello world from Elixir"
  end

  test "format_links_with_domain" do
    url = "http://domain.com/some/link"
    links = ["/some/post.atom"]
    assert STNL.format_links_with_domain(url, links) == ["http://domain.com/some/post.atom"]
  end

  test "format_links_with_domain with https" do
    url = "https://www.domain.com/some/link"
    links = ["/some/post.atom"]
    assert STNL.format_links_with_domain(url, links) == ["https://www.domain.com/some/post.atom"]
  end

  test "adjust domain" do
    domain = "https://domain.com/some/link"
    link = "https://domain.com/some/post.atom"
    assert STNL.adjust_domain(domain, link) == "https://domain.com/some/post.atom"
  end
end
