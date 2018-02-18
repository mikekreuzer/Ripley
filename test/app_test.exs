defmodule AppTest do
  @moduledoc false
  use ExUnit.Case, async: false
  alias Ripley.{App, Helper}

  test "Ripley.App - There is a list of languages" do
    list_of_languages = Application.fetch_env!(:ripley, :subreddits)
    number_of_languages = length(list_of_languages)
    assert number_of_languages > 0

    on_exit(fn ->
      Helper.stop_app()
    end)
  end

  test "Ripley.App - The app started and can't restart while it's running" do
    app_pid = Process.whereis(App)

    if app_pid == nil or !Process.alive?(app_pid) do
      App.start(0, 0)
    end

    assert {:error, {:already_started, _}} = App.start(0, 0)

    on_exit(fn ->
      Helper.stop_app()
    end)
  end
end
