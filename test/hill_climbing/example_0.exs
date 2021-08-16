alias Meta.HillClimbing.Solver
alias Meta.HillClimbing.State.Variable
alias Meta.HillClimbing.State.Constraint
alias Meta.HillClimbing.State.Solution

{:ok, file} = File.open("./runs/example_0_#{DateTime.now!("Etc/UTC") |> DateTime.to_iso8601}.log", [:append])

options = [
  objective: &Meta.Functions.simple_example/1,
  variables: [
    %Variable{
      name: :x,
      constraint: %Constraint{lower_boundary: 0, higher_boundary: 10}
    }
  ],
  noise_size: 0.5,
  max_iterations: 200,
  max_consecutive_no_progress_iterations: 60
]

for i <- 1..30 do
  {:ok, pid} = Solver.setup(options)

  with solution = %Solution{} <- Solver.solve(pid) do
    IO.binwrite(file, "#{inspect(solution)}\n")
  end
end
