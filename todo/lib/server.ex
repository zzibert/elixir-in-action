defmodule Todo.Server do
  use GenServer

  alias Todo.List

  # CLIENT #

  def start(name) do
    GenServer.start(__MODULE__, name)
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  # CALLBACKS #

  @impl GenServer
  def init(name) do
    {:ok, %{list: List.new(), name: name}}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, %{list: list} = state) do
    {:noreply, %{state | list: List.add_entry(list, new_entry)}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, %{list: list} = state) do
    {:reply, List.entries(list, date), state}
  end
end
