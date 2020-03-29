defmodule Todo.Cache.Test do
  use ExUnit.Case

  alias Todo.Cache

  test "server_process" do
    {:ok, cache} = Cache.start()
    bob_pid = Cache.server_process(cache, "bob")

    assert bob_pid != Cache.server_process(cache, "alice")
    assert bob_pid == Cache.server_process(cache, "bob")
  end
end
