alias Ripley.App

ExUnit.start()

defmodule Ripley.Helper do
  def stop_app do
    #stop the app if it's going
    app_pid = Process.whereis App
    if app_pid != nil && Process.alive? app_pid do
      GenServer.stop app_pid
    end
  end

  def start_genserver(module_name, args) do
    # stop the module if it's going, & restart it
    module_pid = Process.whereis module_name
    if module_pid != nil && Process.alive? module_pid do
      GenServer.stop module_pid
    end
    {:ok, pid} = GenServer.start_link(module_name, args, name: module_name)
    pid
  end

  def start_supervisor(args) do
    super_pid = Process.whereis Ripley.Supervisor
    if super_pid != nil && Process.alive? super_pid do
      GenServer.stop super_pid
    end
    {:ok, pid} = Ripley.Supervisor.start_link args
    pid
  end

end
