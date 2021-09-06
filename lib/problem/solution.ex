defmodule Meta.Problem.Solution do
   @moduledoc """
  Definition of an arbitrary problem solution.

  The `variables` is useful for knowing exactly the parameters used to generate the `value`.
  """
  alias Meta.Problem.Variable

  @derive Jason.Encoder
  @enforce_keys [:variables, :value]
  @type t :: %__MODULE__{variables: list(Variable.t()), value: float}
  defstruct [:variables, :value]
end
