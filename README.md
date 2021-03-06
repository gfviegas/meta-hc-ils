# HC and ILS solver
This project is an academic implementation of both HillClimbing (HC) and Iterated Local Search (ILS) for meta-heuristics learning purposes.

Both heuristics benefits from shared `Meta.Problem` module and it's inner types.

Benchmarks were conducted using the `Meta.Functions.example_one` and `Meta.Functions.example_two` equations and more info is provided in the [Benchmarks Page](benchmarks.md).

[Full Documentation](https://gfviegas.github.io/meta-hc-ils/)

## Code Implementation Details
The algorithms were implemented using the Elixir language in a Mix project environment and ex-docs documentation and an ExUnit testing framework.
All code source is open-source in the [github repository](https://github.com/gfviegas/meta-hc-ils).

Also the [API Reference](https://gfviegas.github.io/meta-hc-ils/api-reference.html#modules) displays all kind of details in modules and structs implemented, as well as the module doc tests.

Overall, the problems were implemented in a pure functional fashion using a `GenServer` and messages-to-self process for quick iteration and control over implementation. More details in the modules docs.
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




