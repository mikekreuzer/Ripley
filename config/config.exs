# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ripley,
  version: "0.9.1"
  # version also defined in mix.exs

case Mix.env do
  :test -> import_config "test.exs"
  _ -> import_config "prod.exs"
end
