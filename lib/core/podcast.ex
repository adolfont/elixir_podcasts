defmodule ElixirPodcasts.Podcast do
  defstruct rss: :a_rss, name: "a name", site: "a site"

  def new(rss) do
    %__MODULE__{rss: rss}
  end

  def new(rss, name) do
    %__MODULE__{rss: rss, name: name}
  end

  def show(podcast) do
    IO.puts("Podcast name: #{podcast.name}")
    IO.puts("Podcast site: #{podcast.site}")
    IO.puts("Podcast RSS: #{podcast.rss}")
    IO.puts("------------")
  end

  def get_info(podcast) do
    podcast
    |> get_title()
  end

  defp get_title(podcast) do
    HTTPoison.start()

    doc = HTTPoison.get!(podcast.rss)

    xml =
      doc.body
      |> String.trim()
      |> String.trim("\n")

    result = Quinn.parse(xml, %{map_attributes: true})

    name = get_field(result, :title)
    site = get_field(result, :link)

    %__MODULE__{podcast | name: name, site: site}
  end

  def get_field(result, atom) do
    Quinn.find(result, atom)
    |> Enum.at(0)
    |> Map.get(:value)
    |> Enum.at(0)
  end

  def all() do
    podcasts = [
      elixir_talk: "http://feeds.soundcloud.com/users/soundcloud:users:334579745/sounds.rss",
      elixir_outlaws: "https://feeds.fireside.fm/elixiroutlaws/rss",
      elixir_fountain: "http://feeds.soundcloud.com/users/soundcloud:users:24638646/sounds.rss",
      elixir_wizards: "https://feeds.fireside.fm/smartlogic/rss",
      elixir_mix: "https://feeds.feedwrench.com/elixirmix.rss",
      thinking_elixir: "https://thinkingelixir.com/feed/podcast/"
    ]

    podcasts
    |> Keyword.values()
    |> Enum.map(&create_and_show/1)
  end

  defp create_and_show(rss) do
    rss
    |> new()
    |> get_info()
    |> show()
  end
end

# IO.puts "oi"
ElixirPodcasts.Podcast.all()
