defmodule Meta.HillClimbing.Solver do
  require Logger

  use GenServer
  alias Meta.HillClimbing.State
  alias Meta.HillClimbing.State.Constraint
  alias Meta.HillClimbing.State.Solution
  alias Meta.HillClimbing.State.Variable

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

    variables = Enum.map(opts[:variables], &generate_random_variable_value/1)
    Logger.info("Variáveis: #{inspect(variables)}")
    initial_solution = generate_random_solution(opts[:objective], variables)

    Logger.info(
      "Value: #{initial_solution.value}, Variables: #{inspect(initial_solution.variables)}"
    )

    is =
      opts
      |> Enum.into(%{})
      |> Map.merge(%{variables: variables, solution: initial_solution, current_iteration: 1})

    initial_state = struct!(State, is)
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:start_solve, from, state) do
    Logger.info("Inicializando processo de convergência...")

    state = %State{state | pid: from}
    Logger.info("Solução final: #{state.solution.value}")
    {:noreply, state, {:continue, :next_iteration}}
  end

  @impl true
  def handle_continue(:next_iteration, state = %State{no_progress_iterations: i, max_consecutive_no_progress_iterations: i}) do
    Logger.info("Processo finalizado por máximo de iterações sem evolução!")
    GenServer.reply(state.pid, state.solution)
    {:noreply, state}
  end

  @impl true
  def handle_continue(:next_iteration, state = %State{current_iteration: i, max_iterations: i}) do
    Logger.info("Processo finalizado por máximo de iterações!")
    GenServer.reply(state.pid, state.solution)
    {:noreply, state}
  end

  @impl true
  def handle_continue(:next_iteration, state = %State{current_iteration: i}) do
    Logger.info("Iteração ##{i}")

    new_variables =
      Enum.map(state.variables, fn v ->
        maybe_tweak_variable(v, state.tweak_probability, state.noise_size)
      end)

    solution = fetch_solution(state.objective, new_variables)
    Logger.info("Value: #{solution.value}, Variables: #{inspect(solution.variables)}")

    new_state =
      if is_better?(solution, state.solution, state.type) do
        %State{
          state
          | variables: new_variables,
            solution: solution,
            no_progress_iterations: 0
        }
      else
        %State{
          state | no_progress_iterations: state.no_progress_iterations + 1
        }
      end

    {:noreply, %State{new_state | current_iteration: i + 1}, {:continue, :next_iteration}}
  end

  # Passo 1: Gerar uma solução aleatória
  @spec generate_random_solution(fun(), [Variable.t()]) :: Solution.t()
  def generate_random_solution(objective, variables) do
    # Gera números randômicos para cada variável
    fetch_solution(objective, variables)
  end

  @spec generate_random_variable_value(Variable.t()) :: Variable.t()
  def generate_random_variable_value(variable = %Variable{constraint: constraint}) do
    %Constraint{higher_boundary: hb, lower_boundary: lb} = constraint
    random_value = (hb - lb) * :rand.uniform() + lb
    %Variable{variable | value: random_value}
  end

  @spec maybe_tweak_variable(Variable.t(), float, float) :: Variable.t()
  def maybe_tweak_variable(variable = %Variable{}, probability, noise_size)
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

  @spec tweak_variable(Variable.t(), float()) :: Variable.t()
  def tweak_variable(variable = %Variable{value: value, constraint: constraint}, noise_size) do
    %Constraint{higher_boundary: constraint_hb, lower_boundary: constraint_lb} = constraint

    hb = if abs(constraint_hb - value) < abs(noise_size) do (constraint_hb - value) else noise_size end
    lb = if abs(value - constraint_lb) < abs(noise_size) do -(value - constraint_lb) else -noise_size end

    random_delta = (hb - lb) * :rand.uniform() + lb
    Logger.info(delta: random_delta, hb: hb, lb: lb, value: value)
    %Variable{variable | value: value + random_delta}
  end

  @spec fetch_solution((... -> float), [Variable.t()]) :: Solution.t()
  def fetch_solution(objective, variables) do
    # Calcula a solução
    variable_values = Enum.map(variables, & &1.value)
    solution_value = apply(objective, variable_values)

    %Solution{
      value: solution_value,
      variables: variables
    }
  end

  @spec is_better?(Solution.t(), Solution.t(), atom) :: boolean()
  def is_better?(%Solution{value: sol1}, %Solution{value: sol2}, :minimization), do: sol1 < sol2
  def is_better?(%Solution{value: sol1}, %Solution{value: sol2}, :maximization), do: sol1 > sol2
  def is_better?(_, _, _), do: raise("Invalid type for State given")
end
