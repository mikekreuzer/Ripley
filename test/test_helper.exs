ExUnit.start

defmodule Ripley.Helper do
  def stop_app do
    app_pid = Process.whereis App
    if app_pid != nil && Process.alive? app_pid do
      Application.stop app_pid
    end
  end

  def stop_genserver(module_name) do
    module_pid = Process.whereis module_name
    if module_pid != nil && Process.alive? module_pid do
      GenServer.stop module_pid, :normal
    end
  end

  def stop_supervisor do
    super_pid = Process.whereis Ripley.Supervisor
    if super_pid != nil && Process.alive? super_pid do
      Supervisor.stop super_pid, :normal
    end
  end

end
