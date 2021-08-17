defmodule Meta.Problem.Solution do
  alias Meta.Problem.Variable

  @derive Jason.Encoder
  @enforce_keys [:variables, :value]
  @type t :: %__MODULE__{variables: list(Variable.t()), value: float}
  defstruct [:variables, :value]
end
