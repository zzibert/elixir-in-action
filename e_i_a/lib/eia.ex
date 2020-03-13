defmodule EIA do
  def area(a), do: area(a, a)

  def area(a, b), do: a * b

  def sum(a), do: sum(a, 0)

  defp sum(a, b), do: a + b

  def double(a), do: sum(a, a)
end
