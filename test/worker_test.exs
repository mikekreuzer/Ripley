defmodule Ripley.WorkerTest do
  alias Ripley.{Helper, Language, Tally, Worker}
  use ExUnit.Case, async: false

  setup do
    {:ok, pid_ok} = Worker.start_link %Language{url: "https://www.reddit.com/r/elixir/"}
    {:ok, pid_404} = Worker.start_link %Language{url: "https://www.reddit.com/r/not_there/"}
    {:ok, pid_err} = Worker.start_link %Language{url: "https://www.reddit.com/r/error/"}
    {:ok, pids: %{ok: pid_ok, err404: pid_404, err: pid_err}}
  end

  test "Ripley.Worker starts", %{pids: pids} do
    assert Process.alive? pids.ok
    assert Process.alive? pids.err404
    assert Process.alive? pids.err
  end

  test "Ripley.Worker.scrape", %{pids: pids} do
    Application.ensure_all_started :httpoison
    Application.ensure_all_started :timex
    timeout = 0

    Helper.stop_genserver Tally
    {:ok, tally_pid} = Tally.start_link 1
    Worker.scrape(pids.ok, timeout)
    language = %Language{url: "https://www.reddit.com/r/elixir/", name: "Worker test"}
    Worker.handle_cast({:scrape, timeout}, language)
    assert :sys.get_state(tally_pid) == %{data: [%Language{index: 0,
                                                     name: "Worker test",
                                                     percentage: 0,
                                                     subscribers: 5_286,
                                                     subsstring: "5,286",
                                                     url: "https://www.reddit.com/r/elixir/"}],
                                           num: 1}

    on_exit fn -> Helper.stop_genserver Tally end
  end

  test "Ripley.Worker.scrape errors" do
    Application.ensure_all_started :httpoison
    timeout = 0

    assert_raise RuntimeError, "Error code: 302", fn ->
      language = %Language{url: "https://www.reddit.com/r/not_there/"}
      Worker.handle_cast({:scrape, timeout}, language)
    end

    assert_raise RuntimeError, "Error: Weird error", fn ->
      language = %Language{url: "https://www.reddit.com/r/error/"}
      Worker.handle_cast({:scrape, timeout}, language)
    end
  end

end
