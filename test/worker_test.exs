defmodule WorkerTest do
  use ExUnit.Case, async: false
  alias Ripley.{Language, Worker}

  describe "Ripley.Worker.start_link" do
    test "starts" do
      {:ok, pid} = Worker.start_link %Language{}
      assert Process.alive? pid
    end
  end

  '''
  describe "Ripley.Worker.scrape and Ripley.Worker.handle_cast" do
    test "error" do
      {:ok, pid} = Worker.start_link %Language{url: "http://mikekreuzer.com/no"}
      assert_raise RuntimeError, fn ->
        Worker.scrape(pid, 0)
        GenServer.stop pid
      end
    end
  end

  describe "Ripley.Worker.terminate" do

  end
  '''

end
