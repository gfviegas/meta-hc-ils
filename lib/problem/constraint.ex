defmodule Meta.Problem.Constraint do
  @derive Jason.Encoder
  @type t :: %__MODULE__{lower_boundary: float, higher_boundary: float}
  defstruct lower_boundary: 0, higher_boundary: 0
end
