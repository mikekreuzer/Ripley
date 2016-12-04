# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

case Mix.env do
  :test -> import_config "test.exs"
  _ -> import_config "prod.exs"
end
