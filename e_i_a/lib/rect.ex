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
end
