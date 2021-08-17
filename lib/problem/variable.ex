defmodule Meta.Problem.Variable do
  alias Meta.Problem.Constraint

  @derive Jason.Encoder
  @enforce_keys [:name]
  @type t :: %__MODULE__{value: float, name: atom(), constraint: Constraint.t()}
  defstruct [:name, :value, constraint: %Constraint{}]
end
