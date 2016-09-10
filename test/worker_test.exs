defmodule WorkerTest do
  use ExUnit.Case, async: false
  alias Ripley.{Helper, Language, Tally, Worker}

  describe "Ripley.Worker.start_link" do
    test "starts" do
      {:ok, pid} = Worker.start_link %Language{}
      assert Process.alive? pid
    end
  end

  describe "Ripley.Worker.scrape" do
    test "success" do
      {:ok, pid} = Worker.start_link %Language{url: "https://www.reddit.com/r/elixir"}
      Worker.scrape(pid, 0)
      assert Process.alive? pid
    end

    test "404" do
      assert_raise RuntimeError, "Error code: 404", fn ->
        language = %Language{url: "https://www.reddit.com/r/not_there"}
        Worker.handle_cast({:scrape, 0}, language)
      end
    end

    test "weird error" do
      assert_raise RuntimeError, "Error: Weird error", fn ->
        language = %Language{url: "https://www.reddit.com/r/error"}
        Worker.handle_cast({:scrape, 0}, language)
      end
    end
  end

  describe "Ripley.Worker.terminate" do
    test "append" do
      Helper.stop_app
      _pid = Helper.start_genserver Tally, 2

      test_lang = %Language{name: "No", url: "http://localhost/no"}
      {:ok, worker_pid} = GenServer.start Worker, test_lang
      GenServer.stop worker_pid, :shutdown

      assert :sys.get_state(Tally) == %{num: 2,
                                        data: [%Language{index: 0,
                                                         percentage: 0,
                                                         subscribers: 0,
                                                         subsstring: "",
                                                         name: "No",
                                                         url: "http://localhost/no"}]}

    end

    test "don't append" do
      Helper.stop_app
      _pid = Helper.start_genserver Tally, 2

      test_lang = %Language{name: "No", url: "http://localhost/no"}
      {:ok, worker_pid} = GenServer.start Worker, test_lang
      GenServer.stop worker_pid

      assert :sys.get_state(Tally) == %{num: 2,
                                        data: []}

    end
  end

end
