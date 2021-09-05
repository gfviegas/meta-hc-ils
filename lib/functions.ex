defmodule Meta.Functions do
  @moduledoc """
  Describes a collection of useful benchmark problems.

  A simple example is provided in `simple_example/1` to serve as a starting point to meta-heuristics testing.

  There is also `example_one/2` and `example_two/2` to provide harder problems in a multimodal environment.
  """

  @doc """
  A simple `x^2` function.
  """
  @spec simple_example(number) :: number
  def simple_example(x) do
    Math.pow(x, 2)
  end

  @spec example_one(number, number) :: float
  def example_one(x, y) do
    Math.sin(x + y) + Math.pow(x - y, 2) - 1.5 * x + 2.5 * y + 1
  end

  @spec example_two(number, number) :: float
  def example_two(x, y) do
    termA =
      (x / 2 + (y + 47))
      |> abs()
      |> Math.sqrt()
      |> Math.sin()

    termB =
      (x - (y + 47))
      |> abs()
      |> Math.sqrt()
      |> Math.sin()

    -((y + 47) * termA - x * termB)
  end
end
