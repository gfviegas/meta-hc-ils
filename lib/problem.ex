defmodule Meta.Problem do
  @moduledoc """
  Definition of a arbitrary optimization problem to be solved using meta-heuristics
  """

  alias Meta.Problem.Variable
  alias Meta.Problem.Constraint
  alias Meta.Problem.Solution

  @derive Jason.Encoder
  @enforce_keys [:variables, :objective]
  @type t :: %__MODULE__{
          variables: [Variable.t()],
          objective: (... -> float),
          solution: Solution.t() | nil,
          type: :minimization | :maximization
        }
  defstruct [
    :objective,
    :solution,
    variables: [],
    type: :minimization
  ]

  @spec fetch_solution((... -> float), [Variable.t()]) :: Solution.t()
  def fetch_solution(objective, variables) do
    # Calcula a solução
    variable_values = Enum.map(variables, & &1.value)
    solution_value = apply(objective, variable_values)

    %Solution{
      value: solution_value,
      variables: variables
    }
  end

  @spec maybe_generate_random_variable_value(Variable.t()) :: Variable.t()
  def maybe_generate_random_variable_value(variable = %Variable{constraint: constraint, value: nil}) do
    %Constraint{higher_boundary: hb, lower_boundary: lb} = constraint
    random_value = (hb - lb) * :rand.uniform() + lb
    %Variable{variable | value: random_value}
  end
  def maybe_generate_random_variable_value(variable = %Variable{constraint: _constraint, value: _v}), do: variable

  def maybe_tweak_variable(variable = %Variable{}, probability, noise_sizes)
      when probability <= 1 and probability >= 0 do
    if :rand.uniform() < probability do
      noise_size = Enum.find_value(noise_sizes, fn {name, value} ->
        if name == variable.name, do: value
      end)

      tweak_variable(variable, noise_size)
    else
      # Retorna a variável como está se a probabilidade não atingir o valor esperado
      variable
    end
  end

  def maybe_tweak_variable(_variable, _probability, _noise),
    do: raise("Invalid probability given")

  @spec tweak_variable(Variable.t(), float()) :: Variable.t()
  def tweak_variable(
        variable = %Variable{value: value, constraint: constraint},
        noise_size
      ) do
    %Constraint{higher_boundary: constraint_hb, lower_boundary: constraint_lb} =
      constraint

    noise = abs(value * noise_size)

    hb =
      if abs(constraint_hb - value) < abs(noise) do
        constraint_hb - value
      else
        noise
      end

    lb =
      if abs(value - constraint_lb) < abs(noise) do
        -(value - constraint_lb)
      else
        -noise
      end

    random_delta = (hb - lb) * :rand.uniform() + lb
    %Variable{variable | value: value + random_delta}
  end

  @spec is_better?(Solution.t(), Solution.t(), atom) :: boolean()
  def is_better?(%Solution{value: sol1}, %Solution{value: sol2}, :minimization), do: sol1 < sol2
  def is_better?(%Solution{value: sol1}, %Solution{value: sol2}, :maximization), do: sol1 > sol2
  def is_better?(_, _, _), do: raise("Invalid type for State given")

  @spec serialize(Solution.t()) :: map()
  def serialize(solution = %Solution{}) do
    Enum.reduce(solution.variables, %{value: solution.value}, fn variable, acc ->
      variable_payload = [{variable.name, variable.value}]
      |> Enum.into(%{})

      Map.merge(acc, variable_payload)
    end)
  end
end
