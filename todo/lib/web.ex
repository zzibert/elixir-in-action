defmodule Todo.Web do
  use Plug.Router

  alias Plug.Adapters.Cowboy

  def child_spec(_arg) do
    Cowboy.child_spec(
      scheme: :http,
      options: [port: 5454],
      plug: __MODULE__
    )
  end
end
