defmodule Todo.Server do
  use GenServer, restart: :temporary

  alias Todo.List

  @expiry_idle_timeout :timer.seconds(10)

  # CLIENT #

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: global_name(name))
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
    {:ok, %{name: name, list: nil}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, %{list: list, name: name} = state) do
    new_list = List.add_entry(list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, %{state | list: new_list}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_call({:entries, date}, _, %{list: list} = state) do
    {:reply, List.entries(list, date), state, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_info(:real_init, %{name: name} = state) do
    {:noreply, %{state | list: Todo.Database.get(name) || Todo.List.new()}, @expiry_idle_timeout}
  end

  @impl GenServer
  def handle_info(:timeout, state) do
    IO.puts("Stopping to-do server for #{state.name}")
    {:stop, :normal, state}
  end

  # Private #

  defp global_name(name) do
    {:global, {__MODULE__, name}}
  end

  def whereis(name) do
    case :global.whereis_name({__MODULE__, name}) do
      :undefined -> nil
      pid -> pid
    end
  end
end
