defmodule Ripley.Mixfile do
  use Mix.Project

  def project do
    [app: :ripley,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison, :timex],
     mod: {Ripley.App, []}]
  end

  defp deps do
    [{:floki, "~> 0.9.0"},
     {:httpoison, "~> 0.9.0"},
     {:poison, "~> 2.0"},
     {:timex, "~> 3.0"}]
  end
end