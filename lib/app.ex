defmodule Ripley.App do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    list_of_languages = Application.fetch_env!(:ripley, :subreddits)
    number_of_languages = length(list_of_languages)

    children = [
      worker(Ripley.Tally, [number_of_languages]),
      worker(Ripley.Supervisor, [list_of_languages])
    ]

    opts = [strategy: :one_for_one, name: Ripley.App]
    Supervisor.start_link(children, opts)
  end
end
