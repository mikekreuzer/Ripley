defmodule Ripley.Mixfile do
  @moduledoc false
  use Mix.Project

  def project do
    [
      aliases: [
        format: "format mix.exs \"lib/**/*.{ex,exs}\" \"test/**/*.{ex,exs}\"",
        run: "run --no-halt",
        test: "coveralls.html --no-start"
      ],
      app: :ripley,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      elixir: "~> 1.6.1",
      log_level: :debug,
      preferred_cli_env: [coveralls: :test, "coveralls.html": :test],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      # version also defined in config/config.exs
      version: "0.9.1"
    ]
  end

  def application do
    [
      applications: [:logger, :httpoison, :timex],
      mod: {Ripley.App, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test]},
      {:ex_doc, "~> 0.16", only: :dev},
      {:excoveralls, "~> 0.8", only: :test},
      {:floki, "~> 0.20.0"},
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.1"}
    ]
  end
end
