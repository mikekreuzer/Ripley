defmodule Ripley.TalleyTest do
  alias Ripley.{Language, Tally}
  use ExUnit.Case, async: false

  setup do
    {:ok, pid} = Tally.start_link 3
    {:ok, pid: pid}
  end

  test "Ripley.Tally starts and we have the right pid", %{pid: pid} do
    assert Process.alive? pid
    assert pid == Process.whereis Tally
  end

  test "Ripley.Tally.start_link sets the expected total", %{pid: pid} do
    assert %{data: [], num: 3} == :sys.get_state(pid)
  end

  test "Ripley.Tally.append and GenServer.cast :append do add data", %{pid: pid} do
    GenServer.cast(pid, {:append, %Language{name: "one", subscribers: 10}})
    assert :sys.get_state(pid) == %{data: [%Language{index: 0,
                                                     name: "one",
                                                     percentage: 0,
                                                     subscribers: 10,
                                                     subsstring: "",
                                                     url: ""}],
                                           num: 3}

    Tally.append(%Language{name: "two", subscribers: 20})
    assert :sys.get_state(pid) == %{data: [%Language{index: 0,
                                                     percentage: 0,
                                                     subsstring: "",
                                                     url: "",
                                                     name: "two",
                                                     subscribers: 20},
                                           %Language{index: 0,
                                                     name: "one",
                                                     percentage: 0,
                                                     subscribers: 10,
                                                     subsstring: "",
                                                     url: ""}],
                                           num: 3}
  end

  test "Ripley.Tally.finish_up and write", %{pid: pid} do
    Application.ensure_all_started :timex

    GenServer.cast(pid, {:append, %Language{name: "one", subscribers: 10}})
    GenServer.cast(pid, {:append, %Language{name: "two", subscribers: 20}})
    GenServer.cast(pid, {:append, %Language{name: "three", subscribers: 30}})

    assert :sys.get_state(pid) == %{data: [%Language{index: 0,
                                                     percentage: 0,
                                                     subsstring: "",
                                                     url: "",
                                                     name: "three",
                                                     subscribers: 30},
                                           %Language{index: 0,
                                                     percentage: 0,
                                                     subsstring: "",
                                                     url: "",
                                                     name: "two",
                                                     subscribers: 20},
                                           %Language{index: 0,
                                                     name: "one",
                                                     percentage: 0,
                                                     subscribers: 10,
                                                     subsstring: "",
                                                     url: ""}],
                                             num: 3}
  end
end
