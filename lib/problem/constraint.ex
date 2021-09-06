defmodule Meta.Problem.Constraint do
   @moduledoc """
  Definition of an arbitrary variable constraints.
  """
  @derive Jason.Encoder
  @type t :: %__MODULE__{lower_boundary: float, higher_boundary: float}
  defstruct lower_boundary: 0, higher_boundary: 0
end
