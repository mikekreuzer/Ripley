defmodule Ripley.Mixfile do
  use Mix.Project

  def project do
    [app: :ripley,
     version: "0.7.0",
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
    [{:credo, "~> 0.4", only: [:dev, :test]},
     {:ex_doc, "~> 0.12", only: :dev},
     {:excoveralls, "~> 0.5", only: :test},
     {:floki, "~> 0.10.1"},
     {:httpoison, "~> 0.9.0"},
     {:poison, "~> 2.0"},
     {:timex, "~> 3.0"}]
  end
end
