alias Meta.HillClimbing.Solver
alias Meta.HillClimbing.State.Variable
alias Meta.HillClimbing.State.Constraint
alias Meta.HillClimbing.State.Solution

{:ok, file} = File.open("./runs/example_2_#{DateTime.now!("Etc/UTC") |> DateTime.to_iso8601}.log", [:append])

options = [
  objective: &Meta.Functions.example_one/2,
  variables: [
    %Variable{
      name: :x,
      constraint: %Constraint{lower_boundary: -1, higher_boundary: 0}
    },
    %Variable{
      name: :y,
      constraint: %Constraint{lower_boundary: -2, higher_boundary: -1}
    }
  ],
  noise_size: 0.05,
  max_iterations: 50,
  max_consecutive_no_progress_iterations: 10
]

for i <- 1..30 do
  {:ok, pid} = Solver.setup(options)

  with solution = %Solution{} <- Solver.solve(pid) do
    IO.binwrite(file, "#{inspect(solution)}\n")
  end
end
