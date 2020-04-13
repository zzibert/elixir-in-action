defmodule EtsKeyValue do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    :ets.new(__MODULE__, [:named_table, :public, write_concurrency: true])
    {:ok, nil}
  end
end
