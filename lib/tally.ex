defmodule Ripley.Tally do
  use GenServer

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
    new_list = [head|tail]

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

    sorted_list = data_list
    |> Enum.sort_by(&(&1.count), &>=/2)

    data = %{"title": title_string, "dateScraped": time_string, "data": sorted_list}
    write_file data
  end

  defp write_file(data) do
    IO.inspect data
    json = Poison.encode!(data)
    |> String.replace(~r/\{\"url/, "\n{\"url") # mildly prettier, new line per value
    File.write! Path.join("data", "interim.json"), json, [:write]
  end

end
