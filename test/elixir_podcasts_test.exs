defmodule ElixirPodcastsTest do
  use ExUnit.Case
  doctest ElixirPodcasts

  test "greets the world" do
    assert ElixirPodcasts.hello() == :world
  end
end
