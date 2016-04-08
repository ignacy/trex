defmodule Trex.StorageCleaner do
  require Logger

  def init(storage_pid) do
    ref = Process.monitor(storage_pid)
    {:ok, ref}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, ref) do
    Logger.info "Closing DETS store on exit."
    :dets.close(Trex.Storage.table_name)
    {:noreply, ref}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
