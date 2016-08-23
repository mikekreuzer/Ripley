defmodule Ripley.Supervisor do
  @moduledoc """
  This module supervises one `Ripley.Worker` per `Ripley.Language`
  """

  alias Ripley.{Language, Worker}

  # api
  def start_link(list_of_languages) do
  import Supervisor.Spec, warn: false
    children = [worker(Worker, [], restart: :temporary)]

    {:ok, sup_pid} = Supervisor.start_link(children,
                                           strategy: :simple_one_for_one,
                                           name: Ripley.Supervisor)

    Enum.each(list_of_languages, &start_up(sup_pid, to_struct(&1)))

    {:ok, sup_pid}
  end

  # working
  defp start_up(sup_pid, lang) do
    {:ok, pid} = Supervisor.start_child(sup_pid, [lang])
    Worker.scrape(pid, 30_000)
  end

  defp to_struct(data) do
    struct(Language, data)
  end

end
