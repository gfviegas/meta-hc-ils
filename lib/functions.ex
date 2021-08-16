defmodule Meta.Functions do
  def simple_example(x) do
    Math.pow(x, 2)
  end

  def example_one(x, y) do
    Math.sin(x + y) + Math.pow(x - y, 2) - 1.5 * x + 2.5 * y + 1
  end
end
