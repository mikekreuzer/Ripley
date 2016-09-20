defmodule Ripley.Worker do
  @moduledoc """
  Module used as a template for the worker for each `Ripley.Language`, started
  by `Ripley.Supervisor`
  """

  use GenServer
  alias Ripley.Tally

  @http_api Application.get_env(:ripley, :http_api)

  #api
  def start_link(language) do
    GenServer.start_link(__MODULE__, language)
  end

  def scrape(pid, timeout) do
    GenServer.cast(pid, {:scrape, timeout})
  end

  # genserver implementation
  def handle_cast({:scrape, timeout}, language) do
    user_agent_string = "Mac:com.mikekreuzer.ripley:0.6.2 (by /u/mikekreuzer)"
    case @http_api.get(language.url,
                       [{"User-Agent", user_agent_string}],
                       [{:timeout, timeout}, {:recv_timeout, timeout}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        text = text_from body
        count = int_from text
        Tally.append(%{language | subscribers: count, subsstring: text})

      {:ok, %HTTPoison.Response{status_code: status}} when status != 200 ->
        raise "Error code: #{status}"

      {:error, %HTTPoison.Error{reason: reason}} ->
        raise "Error: #{reason}"
    end

    {:noreply, language}
  end

  def terminate(reason, language) when reason != :normal do
    Tally.append(language)
    {reason, language}
  end

  def terminate(reason, language) when reason == :normal do
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
