alias Meta.HillClimbing.Solver
alias Meta.Problem

{:ok, file} =
  File.open("./runs/hc/ex_1_#{DateTime.now!("Etc/UTC") |> DateTime.to_iso8601()}.json", [:append])

options = [
  problem: %Problem{
    objective: &Meta.Functions.example_one/2,
    variables: [
      %Problem.Variable{
        name: :x,
        constraint: %Problem.Constraint{lower_boundary: -1.5, higher_boundary: 4}
      },
      %Problem.Variable{
        name: :y,
        constraint: %Problem.Constraint{lower_boundary: -3, higher_boundary: 4}
      }
    ],
  },
  noise_sizes: [x: 0.25, y: 0.25],
  max_iterations: 200,
  max_consecutive_no_progress_iterations: 50
]

solutions = Enum.map(1..30, fn i ->
  {:ok, pid} = Solver.setup(options)

  with solution = %Problem.Solution{} <- Solver.solve(pid) do
    Problem.serialize(solution)
  end
end)

file
|> IO.binwrite(Jason.encode!(solutions))
