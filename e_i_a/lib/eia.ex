defmodule EIA do
  def area(a), do: area(a, a)

  def area(a, b), do: a * b

  def sum(a), do: sum(a, 0)

  def sum(a, b), do: a + b
end
