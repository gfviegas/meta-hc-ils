defmodule Meta.Functions do
  def example_one(x, y) do
    Math.sin(x + y) + Math.pow(x - y, 2) - 1.5 * x + 2.5 * y + 1
  end
end
