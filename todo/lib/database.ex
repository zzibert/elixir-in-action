defmodule Todo.Database do
  use GenServer

  alias Todo.DatabaseWorker

  @db_folder "./persist"

  # CLIENT #

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  # CALLBACKS #

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)

    {:ok, start_workers()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _from, workers) do
    {:reply, Map.get(workers, :erlang.phash2(key, 3)), workers}
  end

  # PRIVATE FUNCS #

  defp start_workers() do
    for index <- 0..2, %{} do
      {:ok, pid} = Todo.DatabaseWorker.start(@db_folder)
      {index, pid}
    end
  end
end
