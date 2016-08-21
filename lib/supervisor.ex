defmodule Ripley.Supervisor do

  # api
  def start_link(list_of_languages) do
  import Supervisor.Spec, warn: false
    children = [worker(Ripley.Worker, [], restart: :temporary)]

    {:ok, sup_pid} = Supervisor.start_link(children,
                                           strategy: :simple_one_for_one,
                                           name: Ripley.Supervisor)

    Enum.each(list_of_languages, &start_up(sup_pid, to_struct(&1)))

    {:ok, sup_pid}
  end

  # working
  defp start_up(sup_pid, lang) do
    {:ok, pid} = Supervisor.start_child(sup_pid, [lang])
    Ripley.Worker.scrape(pid, 30000)
  end

  defp to_struct(data) do
    struct(Ripley.Language, data)
  end

end
