defmodule Ripley.Tally do
  @moduledoc """
  This module is used to tally the results from the `Ripley.Worker` modules
  """

  use GenServer
  alias Ripley.Language

  # api
  def append(language) do
    GenServer.cast(Ripley.Tally, {:append, language})
  end

  def start_link(num_expected) do
    GenServer.start_link(__MODULE__, num_expected, name: Ripley.Tally)
  end

  # genserver implementation
  def init(num_expected) do
    {:ok, %{num: num_expected, data: []}}
  end

  def handle_cast({:append, head}, %{num: num_expected, data: tail}) do
    new_list = [head | tail]

    if length(new_list) >= num_expected do
      finish_up new_list
    end

    {:noreply, %{num: num_expected, data: new_list}}
  end

  # working
  defp finish_up(data_list) do
    time = Timex.now("Australia/Canberra")
    time_string = Timex.format!(time, "%FT%T%:z", :strftime)
    title_string = Timex.format!(time, "%B %Y", :strftime)

    total_subs = data_list
                |> Enum.map(fn(x) -> x.subscribers end)
                |> Enum.reduce(fn(x, acc) -> x + acc end)

    sorted_list = data_list
                  |> Enum.sort_by(&(&1.subscribers), &>=/2)
                  |> Enum.with_index
                  |> Enum.map(&insert_index(&1))
                  |> Enum.map(&insert_percentage(&1, total_subs))

    data = %{"title": title_string,
             "dateScraped": time_string,
             "data": sorted_list}
    write_file data
  
    # GenServer.stop Ripley.App
    app_pid = Process.whereis Ripley.App
    if app_pid != nil && Process.alive? app_pid do
      GenServer.stop app_pid
    end
  end

  defp insert_index(tup) do
    {language, i} = tup
    %Language{language | index: i + 1}
  end

  defp insert_percentage(language, total_subs) do
    percentage = Float.to_string(Float.round(
                                 language.subscribers / total_subs * 100, 1))
    %Language{language | percentage: percentage}
  end

  defp write_file(data) do
    # mildly prettier json, with a new line per value
    json = String.replace(Poison.encode!(data), ~r/\{\"url/, "\n{\"url")
    File.write! Path.join("data", "#{Mix.env}.json"), json, [:write]
  end

end
