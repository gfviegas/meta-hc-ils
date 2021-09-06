defmodule Meta.HillClimbing.Solver do
  @moduledoc """
  Attempt to find a local maximum/minimum value using HillClimbing.

  It uses a `GenServer` and self-sending callback messages to loop through the heuristic iterations until a finish cryteria is reached.
  The implemented cryterias are:
  - `max_iterations`: The maximum amount of allowed callback messages sent to a hillclimb iteration;
  - `max_consecutive_no_progress_iterations`: The maximum amount of consecutive hillclimb iterations without a improvement in the solution;
  """
  require Logger

  use GenServer
  alias Meta.HillClimbing.State
  alias Meta.Problem

  # Client
  @doc """
  Generates a HillClimbing `GenServer` process to solve the problem.

  Return values
  If the server is successfully created and initialized, this function returns `{:ok, pid}`, where pid is the PID of the server. If a process with the specified server name already exists, this function returns `{:error, {:already_started, pid}}` with the PID of that process.

  If the `GenServer:init/1` callback fails with reason, this function returns `{:error, reason}`. Otherwise, if it returns `{:stop, reason}` or `:ignore`, the process is terminated and this function returns {`:error, reason}` or `:ignore`, respectively.

  # Examples

      iex> options = [
            problem: %Meta.Problem{
              objective: &Meta.Functions.simple_example/1,
              variables: [
                %Meta.Problem.Variable{
                  name: :x,
                  constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 10}
                }
              ],
            },
            noise_sizes: [x: 0.25],
            max_iterations: 200,
            max_consecutive_no_progress_iterations: 50
          ]
      iex> Meta.Solver.setup(opts)
      {:ok, #PID<>}
  """
  @spec setup(keyword()) :: GenServer.on_start()
  def setup(opts) when is_list(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @doc """
  Solves for HillClimbing the problem configured in the provided `pid` server.

  # Logs
  Useful logs are used with the `Logger` module, regarding info of the iteration index and the solution found at that index.
  It is also logged when the process is finished and which cryteria was used to terminate the execution:
  ```
      15:28:26.504 mfa=Meta.HillClimbing.Solver.handle_continue/2 [info]  Solution #1: %Meta.Problem.Solution{value: 51.660402502492126, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 7.187517130587733}]}

      15:28:26.504 mfa=Meta.HillClimbing.Solver.handle_continue/2 [info]  Solution #2: %Meta.Problem.Solution{value: 80.21040204576592, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 8.956026018595855}]}

      15:28:26.504 mfa=Meta.HillClimbing.Solver.handle_continue/2 [info]  Solution #3: %Meta.Problem.Solution{value: 49.492197212573195, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 7.035069097924568}]}

      ...

      15:28:26.529 mfa=Meta.HillClimbing.Solver.handle_continue/2 [info]  Solution #197: %Meta.Problem.Solution{value: 6.841908964815985e-11, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 8.271583261272285e-6}]}

      15:28:26.529 mfa=Meta.HillClimbing.Solver.handle_continue/2 [info]  Solution #198: %Meta.Problem.Solution{value: 4.2071463961827206e-11, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 6.4862519193928325e-6}]}

      15:28:26.529 mfa=Meta.HillClimbing.Solver.handle_continue/2 [info]  Solution #199: %Meta.Problem.Solution{value: 5.924935935911621e-11, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 7.697360544960604e-6}]}

      15:28:26.529 mfa=Meta.HillClimbing.Solver.handle_continue/2 [info]  Process finished by reason: 'Maximum iterations reached: 200'!
  ```
  # Return values
  A `Meta.Problem.Solution` is yielded when the process converges.

  # Examples

      iex> options = [
            problem: %Meta.Problem{
              objective: &Meta.Functions.simple_example/1,
              variables: [
                %Meta.Problem.Variable{
                  name: :x,
                  constraint: %Meta.Problem.Constraint{lower_boundary: 0, higher_boundary: 10}
                }
              ],
            },
            noise_sizes: [x: 0.25],
            max_iterations: 200,
            max_consecutive_no_progress_iterations: 50
          ]
      iex> {:ok, pid} = Meta.Solver.setup(opts)
      iex> Meta.Solver.solve(pid)
      %Meta.Problem.Solution{
        value: 4.2071463961827206e-11,
        variables: [
          %Meta.Problem.Variable{
            constraint: %Meta.Problem.Constraint{
              higher_boundary: 10,
              lower_boundary: 0
            },
            name: :x,
            value: 6.4862519193928325e-6
          }
        ]
      }
  """
  @spec solve(pid()) :: Problem.Solution.t()
  def solve(pid) do
    GenServer.call(pid, :start_solve, :infinity)
  end

  # Server (callbacks)
  @doc false
  @impl true
  def init(opts) do
    Logger.info("Initializing problem...")

    with problem = %Problem{} <- opts[:problem],
         variables <-
           Enum.map(problem.variables, &Problem.maybe_generate_random_variable_value/1),
         initial_solution <- Problem.fetch_solution(problem.objective, variables) do
      Logger.info("Initial solution: #{inspect(initial_solution)}")

      updated_problem = %Problem{problem | variables: variables, solution: initial_solution}

      initial_state =
        opts
        |> Enum.into(%{})
        |> Map.merge(%{problem: updated_problem, current_iteration: 1})

      initial_state = struct!(State, initial_state)
      {:ok, initial_state}
    end
  end

  @doc false
  @impl true
  def handle_call(:start_solve, from, state) do
    Logger.info("Starting iterations to converge problem...")

    state = %State{state | pid: from}
    {:noreply, state, {:continue, :next_iteration}}
  end

  @doc false
  @impl true
  def handle_continue(
        :next_iteration,
        state = %State{no_progress_iterations: i, max_consecutive_no_progress_iterations: i}
      ) do
    Logger.info("Process finished by reason: 'Maximum consecutive iterations without progress reached: #{i}'!")
    GenServer.reply(state.pid, state.problem.solution)
    {:noreply, state}
  end

  @doc false
  @impl true
  def handle_continue(:next_iteration, state = %State{current_iteration: i, max_iterations: i}) do
    Logger.info("Process finished by reason: 'Maximum iterations reached: #{i}'!")
    GenServer.reply(state.pid, state.problem.solution)
    {:noreply, state}
  end

  @doc false
  @impl true
  def handle_continue(:next_iteration, state = %State{current_iteration: i}) do
    with problem = %Problem{} <- state.problem,
         new_variables <-
           Enum.map(
             state.problem.variables,
             &Problem.maybe_tweak_variable(&1, state.tweak_probability, state.noise_sizes)
           ),
         solution <- Problem.fetch_solution(state.problem.objective, new_variables) do
      Logger.info("Solution ##{i}: #{inspect(solution)}")

      is_solution_better? = Problem.is_better?(solution, problem.solution, problem.type)

      {updated_problem, updated_npi} =
        if is_solution_better? do
          {%Problem{problem | variables: new_variables, solution: solution}, 0}
        else
          {problem, state.no_progress_iterations + 1}
        end

      new_state = %State{
        state
        | problem: updated_problem,
          no_progress_iterations: updated_npi,
          current_iteration: i + 1
      }

      {:noreply, %State{new_state | current_iteration: i + 1}, {:continue, :next_iteration}}
    end
  end
end
