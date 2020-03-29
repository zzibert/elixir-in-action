defmodule Todo.Cache.Test do
  use ExUnit.Case

  alias Todo.Cache

  test "server_process" do
    {:ok, cache} = Cache.start()
    bob_pid = Cache.server_process(cache, "bob")

    assert bob_pid != Cache.server_process(cache, "alice")
    assert bob_pid == Cache.server_process(cache, "bob")
  end

  test "to-do operations" do
    {:ok, cache} = Todo.Cache.start()
    alice = Todo.Cache.server_process(cache, "alice")
    Todo.Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Dentist"})
    entries = Todo.Server.entries(alice, ~D[2018-12-19])

    assert [%{date: ~D[2018-12-19], title: "Dentist"}] = entries
  end
end
