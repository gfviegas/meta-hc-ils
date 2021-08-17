defmodule Meta.HillClimbing.Solver do
  require Logger

  use GenServer
  alias Meta.HillClimbing.State
  alias Meta.Problem

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
         variables <- Enum.map(problem.variables, &Problem.generate_random_variable_value/1),
         initial_solution <- Problem.generate_random_solution(problem.objective, variables) do
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
             &maybe_tweak_variable(&1, state.tweak_probability, state.noise_size)
           ),
         solution <- Problem.fetch_solution(state.problem.objective, new_variables) do
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

  @spec maybe_tweak_variable(Problem.Variable.t(), float, float) :: Problem.Variable.t()
  def maybe_tweak_variable(variable = %Problem.Variable{}, probability, noise_size)
      when probability <= 1 and probability >= 0 do
    if :rand.uniform() < probability do
      tweak_variable(variable, noise_size)
    else
      # Retorna a variável como está se a probabilidade não atingir o valor esperado
      variable
    end
  end

  def maybe_tweak_variable(_variable, _probability, _noise),
    do: raise("Invalid probability given")

  @spec tweak_variable(Problem.Variable.t(), float()) :: Problem.Variable.t()
  def tweak_variable(
        variable = %Problem.Variable{value: value, constraint: constraint},
        noise_size
      ) do
    %Problem.Constraint{higher_boundary: constraint_hb, lower_boundary: constraint_lb} =
      constraint

    hb =
      if abs(constraint_hb - value) < abs(noise_size) do
        constraint_hb - value
      else
        noise_size
      end

    lb =
      if abs(value - constraint_lb) < abs(noise_size) do
        -(value - constraint_lb)
      else
        -noise_size
      end

    random_delta = (hb - lb) * :rand.uniform() + lb
    %Problem.Variable{variable | value: value + random_delta}
  end
end
