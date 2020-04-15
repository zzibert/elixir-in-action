defmodule SimpleRegistry do
  use GenServer

  # Interface #

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register(name) do
    GenServer.call(__MODULE__, {:register, name, self()})
  end

  def whereis(name) do
    GenServer.call(__MODULE__, {:whereis, name})
  end

  # Callbacks

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:register, name, pid}, _, state) do
    case Map.get(state, name) do
      nil ->
        Process.link(pid)
        {:reply, :ok, Map.put(state, name, pid)}
      _ ->
        {:reply, :error, state}
    end
  end

  @impl GenServer
  def handle_call({:whereis, name}, _from, state) do
    {:reply, Map.get(state, name), state}
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _reason}, state) do
    new_state =
      state
      |> Enum.reject(fn {_key, value} -> value == pid end)
      |> Enum.into(%{})

    {:noreply, new_state}
  end
end
