defmodule Ripley.Mixfile do
  use Mix.Project

  def project do
    [app: :ripley,
     version: "0.7.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test,
                         "coveralls.html": :test],
     aliases: [test: "coveralls.html --no-start"]
   ]
  end

  def application do
    [applications: [:logger, :httpoison, :timex],
     mod: {Ripley.App, []}]
  end

  defp deps do
    [{:credo, "~> 0.8", only: [:dev, :test]}, # from 0.5
     {:ex_doc, "~> 0.14", only: :dev},
     {:excoveralls, "~> 0.6", only: :test},   # from 0.5
     {:floki, "~> 0.17.0"},                   # from 0.13.1
     {:httpoison, "~> 0.11.1"},               # from 0.10.0
     {:poison, "~> 3.1"},                     # from 3.1
     {:timex, "~> 3.0"}]
  end
end
