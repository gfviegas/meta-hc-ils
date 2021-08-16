defmodule Meta.HillClimbing.State do
  defmodule Constraint do
    @type t :: %__MODULE__{lower_boundary: float, higher_boundary: float}
    defstruct lower_boundary: 0, higher_boundary: 0
  end

  defmodule Solution do
    @enforce_keys [:variables, :value]
    @type t :: %__MODULE__{variables: list(Variable.t()), value: float}
    defstruct [:variables, :value]
  end

  defmodule Variable do
    @enforce_keys [:name]
    @type t :: %__MODULE__{value: float, name: atom(), constraint: Constraint.t()}
    defstruct [:name, :value, constraint: %Constraint{}]
  end

  @enforce_keys [:variables, :objective]
  @type t :: %__MODULE__{
          variables: [Variable.t()],
          objective: (... -> float),
          solution: Solution.t() | nil,
          type: :minimization | :maximization,
          noise_size: float(),
          tweak_probability: float(),
          max_iterations: non_neg_integer(),
          current_iteration: non_neg_integer(),
          max_consecutive_no_progress_iterations: non_neg_integer(),
          no_progress_iterations: non_neg_integer()
        }
  defstruct [
    :objective,
    :solution,
    :current_iteration,
    variables: [],
    type: :minimization,
    noise_size: 0.1,
    tweak_probability: 1,
    max_iterations: 50,
    max_consecutive_no_progress_iterations: 10,
    no_progress_iterations: 0
  ]
end
