# HC and ILS solver
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


[Full Documentation](https://gfviegas.github.io/meta-hc-ils/)
### Generating Docs
With the Docker environment, to generate a docs folder with the ExDoc files is easy as
```bash
docker-compose run tp1 mix docs --output docs
```
### Testing
Automated test is also implemented in moduledocs test, and can be run with the command below:
```bash
docker-compose run tp1 mix test
```

Which will yield a result close to the one below:
```bash
root@99e6f88b669d:/code# mix test
Compiling 10 files (.ex)
Generated code app
............

Finished in 0.05 seconds (0.05s async, 0.00s sync)
12 doctests, 0 failures
```




