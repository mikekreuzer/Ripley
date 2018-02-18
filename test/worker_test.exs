defmodule Ripley.WorkerTest do
  @moduledoc false
  alias Ripley.{Helper, Language, Tally, Worker}
  use ExUnit.Case, async: false

  setup do
    {:ok, pid_ok} =
      Worker.start_link(%Language{url: "https://www.reddit.com/r/elixir/", name: "Elixir"})

    {:ok, pid_302} =
      Worker.start_link(%Language{url: "https://www.reddit.com/r/not_there/", name: "Not there"})

    {:ok, pid_err} =
      Worker.start_link(%Language{url: "https://www.reddit.com/r/error/", name: "Error"})

    {:ok, pids: %{ok: pid_ok, err302: pid_302, err: pid_err}}
  end

  test "Ripley.Worker starts", %{pids: pids} do
    assert Process.alive?(pids.ok)
    assert Process.alive?(pids.err302)
    assert Process.alive?(pids.err)
  end

  test "Ripley.Worker.scrape", %{pids: pids} do
    Application.ensure_all_started(:httpoison)
    Application.ensure_all_started(:timex)
    timeout = 0

    Helper.stop_genserver(Tally)
    {:ok, tally_pid} = Tally.start_link(1)
    Worker.scrape(pids.ok, timeout)
    GenServer.stop(pids.ok, :normal)

    assert :sys.get_state(tally_pid) == %{
             data: [
               %Language{
                 index: 0,
                 name: "Elixir",
                 percentage: 0,
                 subscribers: 5_286,
                 subsstring: "5,286",
                 url: "https://www.reddit.com/r/elixir/"
               }
             ],
             num: 1
           }

    on_exit(fn -> Helper.stop_genserver(Tally) end)
  end

  test "Ripley.Worker.scrape 302 error", %{pids: pids} do
    Application.ensure_all_started(:httpoison)
    Application.ensure_all_started(:timex)
    timeout = 0

    Helper.stop_genserver(Tally)
    {:ok, tally_pid} = Tally.start_link(1)
    Worker.scrape(pids.err302, timeout)
    GenServer.stop(pids.err302, :normal)

    assert :sys.get_state(tally_pid) == %{
             data: [
               %Language{
                 index: 0,
                 name: "Not there",
                 subscribers: 1,
                 subsstring: "Error code: 302",
                 url: "https://www.reddit.com/r/not_there/"
               }
             ],
             num: 1
           }

    on_exit(fn -> Helper.stop_genserver(Tally) end)
  end

  test "Ripley.Worker.scrape unknown error", %{pids: pids} do
    Application.ensure_all_started(:httpoison)
    Application.ensure_all_started(:timex)
    timeout = 0

    Helper.stop_genserver(Tally)
    {:ok, tally_pid} = Tally.start_link(1)
    Worker.scrape(pids.err, timeout)
    GenServer.stop(pids.err, :normal)

    assert :sys.get_state(tally_pid) == %{
             data: [
               %Language{
                 index: 0,
                 name: "Error",
                 subscribers: 1,
                 subsstring: "Error: Weird error",
                 url: "https://www.reddit.com/r/error/"
               }
             ],
             num: 1
           }

    on_exit(fn -> Helper.stop_genserver(Tally) end)
  end
end
