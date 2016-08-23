defmodule Ripley.Worker do
  use GenServer

  #api
  def start_link(language) do
    GenServer.start_link(__MODULE__, language)
  end

  def scrape(pid, timeout) do
    GenServer.cast(pid, {:scrape, timeout})
  end

  # genserver implementation
  def handle_cast({:scrape, timeout}, language) do
    case HTTPoison.get(language.url,
                       [{"User-Agent", "Mac:com.mikekreuzer.ripley:0.3.0 (by /u/mikekreuzer)"}],
                       [{:timeout, timeout}, {:recv_timeout, timeout}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        text = text_from body
        count = int_from text
        Ripley.Tally.append(%{language | count: count, countStr: text})

      {:ok, %HTTPoison.Response{status_code: status}} when status != 200 ->
        raise "Error code: #{status}"

      {:ok, %HTTPoison.Error{reason: reason}} ->
        raise "Error: #{reason}"
    end

    {:noreply, language}
  end

  def terminate(reason, language) when reason != :normal do
    Ripley.Tally.append(language)
    {reason, language}
  end

  # working
  defp int_from(text) do
    {int, _} = text
    |> String.replace(",", "")
    |> Integer.parse
    int
  end

  defp text_from(html) do
    html
    |> Floki.find(".subscribers .number")
    |> Floki.text
  end
end
