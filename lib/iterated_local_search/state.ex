defmodule Meta.IteratedLocalSearch.State do
  @moduledoc false
  alias Meta.Problem

  defmodule HillClimbingOptions do
    @moduledoc false
    @enforce_keys [:noise_sizes]
    defstruct [
      :noise_sizes,
      tweak_probability: 1,
      max_iterations: 50,
      max_consecutive_no_progress_iterations: 10
    ]
  end

  @enforce_keys [:problem, :hc_options]
  @type t :: %__MODULE__{
          pid: pid,
          problem: Problem.t(),
          hc_options: HillClimbingOptions.t(),
          pertubation_size: float(),
          max_iterations: non_neg_integer(),
          current_iteration: non_neg_integer(),
          max_consecutive_no_progress_iterations: non_neg_integer(),
          no_progress_iterations: non_neg_integer()
        }
  defstruct [
    :pid,
    :problem,
    :current_iteration,
    :hc_options,
    pertubation_size: 0.1,
    max_iterations: 50,
    max_consecutive_no_progress_iterations: 10,
    no_progress_iterations: 0
  ]
end
