defmodule Calculator do
  def start do
    spawn(fn -> loop(0) end)
  end

  def value(server_pid) do
    send(server_pid, {:value, self()})
    receive do
      {:response, value} ->
        value
    end
  end

  defp loop(current_value) do
    new_value =
      receive do
        {:value, caller} ->
          send(caller, {:response, current_value})
          current_value
        {:add, value} -> current_value + value
        {:sub, value} -> current_value - value
        {:mul, value} -> current_value * value
        {:div, value} -> current_value / value

        invalid_request ->
          IO.puts("Invalid request: #{invalid_request}")
          current_value
      end
    loop(new_value)
  end
end
