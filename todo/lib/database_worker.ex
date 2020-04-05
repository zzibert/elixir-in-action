defmodule Todo.DatabaseWorker do
  use GenServer

  # CLIENT #

  def start_link(db_folder) do
    GenServer.start_link(__MODULE__, db_folder)
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def store(pid, key, data) do
    GenServer.cast(pid, {:store, key, data})
  end

  # CALLBACKS #

  @impl GenServer
  def init(db_folder) do
    IO.puts("Starting Database Worker.")
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    key
    |> file_name(db_folder)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  @impl GenServer
  def handle_call({:get, key}, _, db_folder) do
    data =
      case File.read(file_name(key, db_folder)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    {:reply, data, db_folder}
  end

  defp file_name(key, db_folder) do
    Path.join(db_folder, to_string(key))
  end
end
