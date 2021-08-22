defmodule Meta.Functions do
  def simple_example(x) do
    Math.pow(x, 2)
  end

  def example_one(x, y) do
    Math.sin(x + y) + Math.pow(x - y, 2) - 1.5 * x + 2.5 * y + 1
  end

  def example_two(x, y) do
    termA = ((x / 2) + (y + 47))
    |> abs()
    |> Math.sqrt()
    |> Math.sin()

    termB = (x - (y + 47))
    |> abs()
    |> Math.sqrt()
    |> Math.sin()

    -(((y + 47) * termA) - (x * termB))
  end
end
