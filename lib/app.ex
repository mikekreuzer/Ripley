defmodule Ripley.App do
  @moduledoc """
  This is the top level app.

  This module supervises `Ripley.Tally` & `Ripley.Supervisor`, the latter starts
  one `Ripley.Worker` for each `Ripley.Language`, the results from those are
  sent to `Ripley.Tally`
  """

  use Application

  @doc """
  Used in `Ripley.Mixfile.application` to start the app, reads the list of
  languages from config.exs, supervises `Ripley.Tally` and `Ripley.Supervisor`

  Returns `{:ok, pid}` or an error, eg `{:error, {:already_started, pid}}`
  """

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
