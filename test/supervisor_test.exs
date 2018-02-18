defmodule Ripley.SupervisorTest do
  @moduledoc false
  use ExUnit.Case, async: false

  setup do
    Application.ensure_all_started(:httpoison)
    Application.ensure_all_started(:timex)

    list_of_languages = Application.fetch_env!(:ripley, :subreddits)
    {:ok, pid} = Ripley.Supervisor.start_link(list_of_languages)
    {:ok, pid: pid}
  end

  test "Ripley.Supervisor - given a list of two language hashes, start two workers", %{pid: pid} do
    assert Process.alive?(pid)

    child_list = Supervisor.which_children(pid)
    assert length(child_list) == 2
  end

  test "Ripley.Supervisor - :temporary strategy, Workers don't restart", %{pid: pid} do
    child_list = Supervisor.which_children(pid)

    Enum.each(child_list, fn child ->
      {_, child_pid, _, _} = child
      GenServer.stop(child_pid)
      assert !Process.alive?(child_pid)
    end)

    child_list = Supervisor.which_children(pid)
    assert child_list == []
  end
end
