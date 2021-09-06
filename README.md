# HillClimbing and Iterated Local Search solver
This project is an academic implementation of both HillClimbing (HC) and Iterated Local Search (ILS) for meta-heuristics learning purposes.

Both heuristics benefits from shared `Meta.Problem` module and it's inner types.

Benchmarks were conducted using the `Meta.Functions.example_one` and `Meta.Functions.example_two` equations and more info is provided in the [Benchmarks Page](benchmarks.md).

[Full Documentation](https://gfviegas.github.io/meta-hc-ils/)
## Running
A `Dockerfile` and `docker-compose.yml` files is provided in this project for quick setup and run:
```bash
docker-compose run tp1
```

The default entrypoint is the running of all benchmarks problems, which can then be further analysed in the `benchmarks/analysis.ipynb` notebook.


