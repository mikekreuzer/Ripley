defmodule TallyTest do
  use ExUnit.Case, async: false
  # doctest Ripley.TallyTest
  alias Ripley.{Helper, Language, Tally}

  describe "Ripley.Tally.start_link" do
    test "start Tally" do
      Helper.stop_app
      pid = Helper.start_genserver Tally, []
      assert Process.alive? pid
    end
  end

  describe "Ripley.Tally.init" do
    test "keep track of the expected number of workers via init" do
      Helper.stop_app
      _pid = Helper.start_genserver Tally, []
      assert {:ok, %{num: 3, data: []}} == Tally.init 3
    end
  end

  describe "Ripley.Tally.append" do
    test "accumulate data" do
      Helper.stop_app
      _pid = Helper.start_genserver Tally, 2
      Tally.append(%Language{name: "one"})
      assert %{data: [%Language{count: 0, countStr: "", name: "one", url: ""}],
               num: 2} == GenServer.call(Tally, :status)
    end
  end

  '''
  describe "Ripley.Tally.finish_up and write" do

  end
  '''
  
end
