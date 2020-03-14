defmodule Rectangle do
  def area({a, b}) do
    a * b
  end

  def area({:rectangle, a, b}) do
    a * b
  end

  def area({:square, a}) do
    a * a
  end

  def test(x) when x < 0 do
    :negative
  end

  def test(0), do: :zero

  def test(x) when x > 0 do
    :positive
  end
end
