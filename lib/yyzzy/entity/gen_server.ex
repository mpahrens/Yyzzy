defmodule Yyzzy.Entity.GenServer do
  use GenServer

  def start_link(yz) do
    GenServer.start_link(__MODULE__, yz)
  end
  def handle_call(:get, _from, yz) do
    {:reply, yz, yz}
  end
  def handle_cast({:update, f}, yz) do
    {:noreply, f.(yz)}
  end
end
