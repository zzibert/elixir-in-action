defmodule Todo.Server do
  use GenServer

  alias Todo.List

  # CLIENT #

  def start_link(name) do
    IO.puts("Starting to-do server for #{name}")
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
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
    send(self(), :real_init)
    {:ok, %{name: name, list: nil}}
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

  @impl GenServer
  def handle_info(:real_init, %{name: name} = state) do
    {:noreply, %{state | list: Todo.Database.get(name) || Todo.List.new()}}
  end

  # Private #

  defp via_tuple(name) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, name})
  end
end
