defmodule Meta.IteratedLocalSearch.Solver do
  require Logger

  use GenServer
  alias Meta.IteratedLocalSearch.State
  alias Meta.Problem
  alias Meta.HillClimbing

  # Client
  def setup(opts) when is_list(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def solve(pid) do
    GenServer.call(pid, :start_solve, :infinity)
  end

  # Server (callbacks)
  @impl true
  def init(opts) do
    Logger.info("Registrando problema...")

    with problem = %Problem{} <- opts[:problem],
         variables <-
           Enum.map(problem.variables, &Problem.maybe_generate_random_variable_value/1),
         initial_solution <- Problem.fetch_solution(problem.objective, variables) do
      Logger.info("Solução inicial: #{inspect(initial_solution)}")

      updated_problem = %Problem{problem | variables: variables, solution: initial_solution}

      initial_state =
        opts
        |> Enum.into(%{})
        |> Map.merge(%{problem: updated_problem, current_iteration: 1})

      initial_state = struct!(State, initial_state)
      {:ok, initial_state}
    end
  end

  @impl true
  def handle_call(:start_solve, from, state) do
    Logger.info("Inicializando processo de convergência...")

    state = %State{state | pid: from}
    {:noreply, state, {:continue, :next_iteration}}
  end

  @impl true
  def handle_continue(
        :next_iteration,
        state = %State{no_progress_iterations: i, max_consecutive_no_progress_iterations: i}
      ) do
    Logger.info("Processo finalizado por máximo de iterações sem evolução!")
    GenServer.reply(state.pid, state.problem.solution)
    {:noreply, state}
  end

  @impl true
  def handle_continue(:next_iteration, state = %State{current_iteration: i, max_iterations: i}) do
    Logger.info("Processo finalizado por máximo de iterações!")
    GenServer.reply(state.pid, state.problem.solution)
    {:noreply, state}
  end

  @impl true
  def handle_continue(:next_iteration, state = %State{current_iteration: i}) do
    with problem = %Problem{} <- state.problem,
         new_variables <-
           Enum.map(
             state.problem.variables,
             fn problem = %Problem.Variable{name: name} ->
               noise_sizes = [{name, state.pertubation_size}]
               Problem.maybe_tweak_variable(problem, 1, noise_sizes)
             end
           ),
         hc_setup =
           Keyword.merge(state.hc_options, problem: %Problem{problem | variables: new_variables}),
         {:ok, hc_pid} <- HillClimbing.Solver.setup(hc_setup),
         solution <- HillClimbing.Solver.solve(hc_pid) do
      Logger.info("Solução ##{i}: #{inspect(solution)}")

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