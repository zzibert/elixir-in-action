defmodule DatabaseServer do
  def start do
    spawn(fn ->
      connection = :rand.uniform(1000)
      loop(connection)
    end)
  end

  defp loop(connection) do
    receive do
      {:run_query, from_pid, query_def} ->
        query_result = run_query(connection, query_def)
        send(from_pid, {:query_result, query_result})
    end
    loop(connection)
  end

  defp run_query(connection, query_def) do
    Process.sleep(2000)
    "Connection #{connection}: #{query_def} result"
  end
end
