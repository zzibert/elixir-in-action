defmodule Todo.Cache do
  use GenServer
  # INTERFACE #

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(pid, todo_list_name) do
    GenServer.call(pid, {:server_process, todo_list_name})
  end

  # CALLBACKS #

  def init(_) do
    Todo.Database.start()

    {:ok, %{}}
  end

  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}

      :error ->
        {:ok, new_server} = Todo.Server.start(todo_list_name)
        {:reply, new_server, Map.put(todo_servers, todo_list_name, new_server)}
    end
  end
end
