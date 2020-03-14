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

  test_num =
    fn
      x when is_number(x) and x < 0 ->
        :negative

      0 -> :zero

      x when is_number(x) and x > 0 ->
        :positive
    end
  test_num.(-5)
  test_num.(0)
  test_num.(5)
end
