defmodule KeyValueStore do
  use GenServer

  # CLIENT

  def start() do

  end

  def init() do
    {:ok, %{}}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, state) do
    {:reply, Map.get(state, key), state}
  end
end

