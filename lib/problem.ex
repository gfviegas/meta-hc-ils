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

  @spec generate_random_variable_value(Variable.t()) :: Variable.t()
  def generate_random_variable_value(variable = %Variable{constraint: constraint}) do
    %Constraint{higher_boundary: hb, lower_boundary: lb} = constraint
    random_value = (hb - lb) * :rand.uniform() + lb
    %Variable{variable | value: random_value}
  end

  @spec generate_random_solution(fun(), [Variable.t()]) :: Solution.t()
  def generate_random_solution(objective, variables) do
    # Gera números randômicos para cada variável
    fetch_solution(objective, variables)
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
