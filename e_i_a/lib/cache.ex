defmodule Todo.Cache do
  use GenServer

  def init(_) do
    {:ok, %{}}
  end
end
