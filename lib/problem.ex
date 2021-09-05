defmodule Meta.Problem do
  @moduledoc """
  Definition of an arbitrary optimization problem to be solved using meta-heuristics.

  To use a problem definition you must provide the `variables` list and the `objective` function.
  The `objective` arity must match the `variables` length and must be placed in a sorted order as the function must be called.

  This module also acknowledges some common functions around Problem solving.
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

  @doc """
  Applies the `objective` function with `variables` and yields a `Solution` struct with the function result and the variables used, useful for logging or history registry.

   # Examples

      iex> fetch_solution(&Meta.Functions.simple_example/1, [%Meta.Problem.Variable{name: :x, value: 3, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 100}}])
      %Meta.Problem.Solution{value: 9, variables: [%Meta.Problem.Variable{name: :x, value: 3, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 100}}]}

      iex> fetch_solution(&Meta.Functions.example_one/2, [%Meta.Problem.Variable{name: :x, value: 10, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 100}}, %Meta.Problem.Variable{name: :y, value: 4, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 100}}])
      %Meta.Problem.Solution{value: 32.99060735569487, variables: [%Meta.Problem.Variable{name: :x, value: 10, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 100}}, %Meta.Problem.Variable{name: :y, value: 4, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 100}}]}
  """
  @spec fetch_solution((... -> float), [Variable.t()]) :: Solution.t()
  def fetch_solution(objective, variables) do
    variable_values = Enum.map(variables, & &1.value)
    solution_value = apply(objective, variable_values)

    %Solution{
      value: solution_value,
      variables: variables
    }
  end

  @doc """
  Seeds a variable `value` field if its nil, generating a random variable value respecting its constraint definitions.
  If the variable already has a value, nothing is changed, hence the maybe name.

   # Examples

      iex> :rand.seed(:exsplus, {101, 102, 103})
      iex> maybe_generate_random_variable_value(%Meta.Problem.Variable{name: :x, value: nil, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}})
      %Meta.Problem.Variable{name: :x, value: 1.489738081165117, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}

      iex> maybe_generate_random_variable_value(%Meta.Problem.Variable{name: :x, value: 1, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}})
      %Meta.Problem.Variable{name: :x, value: 1, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}
  """
  @spec maybe_generate_random_variable_value(Variable.t()) :: Variable.t()
  def maybe_generate_random_variable_value(
        variable = %Variable{constraint: constraint, value: nil}
      ) do
    %Constraint{higher_boundary: hb, lower_boundary: lb} = constraint
    random_value = (hb - lb) * :rand.uniform() + lb
    %Variable{variable | value: random_value}
  end

  def maybe_generate_random_variable_value(
        variable = %Variable{constraint: _constraint, value: _v}
      ),
      do: variable

  @doc """
  Tweak a variable value, to a maximum of a matching variable name in `noise_sizes`.
  The constraints of the variable are respected, so the maximum delta change may be lower than the `noise_size` found.

  The variable is only tweaked if a probability check passes (a random float between 0 and 1 is lower than the `probability` argument).

  It raises an Error if the `probability` is not between 0 and 1
   # Examples

      iex> :rand.seed(:exsplus, {101, 102, 103})
      iex> maybe_tweak_variable(%Meta.Problem.Variable{name: :x, value: 1, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}, 1, [x: 0.25])
      %Meta.Problem.Variable{name: :x, value: 0.978631679333307, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}

      iex> maybe_tweak_variable(%Meta.Problem.Variable{name: :x, value: 1, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}, 0, [x: 0.25])
      %Meta.Problem.Variable{name: :x, value: 1, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}

      iex> :rand.seed(:exsplus, {101, 102, 103})
      iex> maybe_tweak_variable(%Meta.Problem.Variable{name: :x, value: 1, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}, 1, [x: 5000])
      %Meta.Problem.Variable{name: :x, value: 0.9145267173332277, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}
  """
  def maybe_tweak_variable(variable = %Variable{}, probability, noise_sizes)
      when probability <= 1 and probability >= 0 do
    if :rand.uniform() < probability do
      noise_size =
        Enum.find_value(noise_sizes, fn {name, value} ->
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

  @doc """
  Tweak a variable value, to a maximum of a `noise_size`.
  The constraints of the variable are respected, so the maximum delta change may be lower than the `noise_size` found.

   # Examples
      iex> :rand.seed(:exsplus, {101, 102, 103})
      iex> tweak_variable(%Meta.Problem.Variable{name: :x, value: 1, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}, 0.25)
      %Meta.Problem.Variable{name: :x, value: 1.1224345202912793, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}

      iex> :rand.seed(:exsplus, {101, 102, 103})
      iex> tweak_variable(%Meta.Problem.Variable{name: :x, value: 1, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}, 5000)
      %Meta.Problem.Variable{name: :x, value: 1.489738081165117, constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 2}}
  """
  @spec tweak_variable(Variable.t(), float()) :: Variable.t()
  def tweak_variable(
        variable = %Variable{value: value, constraint: constraint},
        noise_size
      ) do
    %Constraint{higher_boundary: constraint_hb, lower_boundary: constraint_lb} = constraint

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

  @doc """
  Compares two solutions and returns if the first is better than the second, based on the problem's type (`:minimization` or `:maximization`).

   # Examples

      iex> is_better?(%Meta.Problem.Solution{value: 2, variables: []}, %Meta.Problem.Solution{value: 1, variables: []}, :minimization)
      false

      iex> is_better?(%Meta.Problem.Solution{value: 2, variables: []}, %Meta.Problem.Solution{value: 1, variables: []}, :maximization)
      true
  """
  @spec is_better?(Solution.t(), Solution.t(), :minimization | :maximization) :: boolean()
  def is_better?(%Solution{value: sol1}, %Solution{value: sol2}, :minimization), do: sol1 < sol2
  def is_better?(%Solution{value: sol1}, %Solution{value: sol2}, :maximization), do: sol1 > sol2
  def is_better?(_, _, _), do: raise("Invalid type for State given")

  @doc """
  Flattens a solution map to a one-dimensional for serialiation purpose.

  The key `value` of solution is passed on along each variable name as key and its corresponding values as value.

  # Examples

      iex> serialize(%Meta.Problem.Solution{value: 5, variables: [%Meta.Problem.Variable{name: :x, value: 0.25}, %Meta.Problem.Variable{name: :y, value: 0.5}]})
      %{value: 5, x: 0.25, y: 0.5}
  """
  @spec serialize(Solution.t()) :: map()
  def serialize(solution = %Solution{}) do
    Enum.reduce(solution.variables, %{value: solution.value}, fn variable, acc ->
      variable_payload =
        [{variable.name, variable.value}]
        |> Enum.into(%{})

      Map.merge(acc, variable_payload)
    end)
  end
end
