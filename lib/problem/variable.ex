defmodule Meta.Problem.Variable do
  @moduledoc """
  Definition of an arbitrary problem variable.

  The `name` is used in problem-solving meta-heuristics algorithms and the `constraint` key is used to respect the boundaries of a problem.
  """
  alias Meta.Problem.Constraint

  @derive Jason.Encoder
  @enforce_keys [:name]
  @type t :: %__MODULE__{value: float, name: atom(), constraint: Constraint.t()}
  defstruct [:name, :value, constraint: %Constraint{}]
end
