defmodule Meta.HillClimbing.State do
  @moduledoc false
  alias Meta.Problem

  @enforce_keys [:problem, :noise_sizes]
  @type t :: %__MODULE__{
          pid: pid,
          problem: Problem.t(),
          noise_sizes: [{atom(), float()}],
          tweak_probability: float(),
          max_iterations: non_neg_integer(),
          current_iteration: non_neg_integer(),
          max_consecutive_no_progress_iterations: non_neg_integer(),
          no_progress_iterations: non_neg_integer()
        }
  defstruct [
    :pid,
    :problem,
    :current_iteration,
    :noise_sizes,
    tweak_probability: 1,
    max_iterations: 50,
    max_consecutive_no_progress_iterations: 10,
    no_progress_iterations: 0
  ]
end
