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
    state =
      case Todo.Database.get(name) do
        content -> content
        _ -> List.new()
      end
    {:ok, %{list: state, name: name}}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, %{list: list, name: name} = state) do
    new_list = List.add_entry(list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, %{state | list: new_list}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, %{list: list} = state) do
    {:reply, List.entries(list, date), state}
  end
end
