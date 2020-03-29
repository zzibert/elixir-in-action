defmodule Todo.Server do
  use GenServer

  alias Todo.List

  # CLIENT #

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  # CALLBACKS #

  @impl GenServer
  def init(_) do
    {:ok, List.new()}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, state) do
    {:noreply, List.add_entry(state, new_entry)}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, state) do
    {:reply, List.entries(state, date), state}
  end
end
