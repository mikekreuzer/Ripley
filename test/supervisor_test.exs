defmodule SupervisorTest do
  use ExUnit.Case, async: false
  alias Ripley.Helper
  # doctest Ripley.Supervisor

  @test_list [%{name: "Elixir", url: "https://www.reddit.com/r/elixir"},
              %{name: "Erlang", url: "https://www.reddit.com/r/erlang"}]

  describe "Ripley.Supervisor.start_link" do
    test "start given a list of language hashes" do
      Helper.stop_app
      super_pid = Helper.start_supervisor @test_list
      assert Process.alive? super_pid
    end

    test "given a list of two language hashes, start two workers" do
      Helper.stop_app
      super_pid = Helper.start_supervisor @test_list
      child_list = Supervisor.which_children super_pid
      assert length(child_list) == 2
    end

    test ":temporary strategy, Workers don't restart, test throws runtime error offline" do
      Helper.stop_app
      super_pid = Helper.start_supervisor @test_list
      child_list = Supervisor.which_children super_pid
      Enum.each(child_list, fn(child) ->
          {_, child_pid, _, _} = child
          GenServer.stop child_pid
          assert !Process.alive? child_pid
        end
      )
      child_list = Supervisor.which_children super_pid
      assert length(child_list) == 0
    end
  end

end
