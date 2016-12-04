use Mix.Config

config :ripley,
  http_api: Ripley.HTTPMock,
  subreddits: [
  	%{name: "Elixir", url: "https://www.reddit.com/r/elixir/"},
    %{name: "Pony", url: "https://www.reddit.com/r/ponylang/"}
  ]
