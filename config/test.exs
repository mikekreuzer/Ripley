use Mix.Config

config :ripley,
  subreddits: [
  	%{name: "Elixir", url: "https://www.reddit.com/r/elixir"},
    %{name: "Pony", url: "https://www.reddit.com/r/ponylang"}
    # %{name: "Nope", url: "http://www.mikekreuzer.com/no"}
  ]
