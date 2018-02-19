defmodule Ripley.Supervisor do
  @moduledoc """
  This module supervises one `Ripley.Worker` per `Ripley.Language`
  """

  alias Ripley.{Language, Worker}

  # api
  def start_link(list_of_languages) do
    {:ok, sup_pid} =
      DynamicSupervisor.start_link(
        __MODULE__,
        list_of_languages,
        name: __MODULE__
      )

    Enum.each(list_of_languages, &start_child(to_struct(&1)))

    {:ok, sup_pid}
  end

  # working
  def start_child(one_language) do
    spec = Supervisor.Spec.worker(Worker, [one_language], restart: :transient)
    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, spec)
    Worker.scrape(pid, 30_000)
    {:ok, pid}
  end

  def init(_common_args) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: []
    )
  end

  defp to_struct(data) do
    struct(Language, data)
  end
end
