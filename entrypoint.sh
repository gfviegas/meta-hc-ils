#!/bin/sh

echo "EXECUTANDO BENCHMARK EXEMPLO"
mix run benchmarks/hill_climbing/example_0.exs

echo "EXECUTANDO BENCHMARK #1 - HILL CLIMBING"
mix run benchmarks/hill_climbing/example_1.exs
echo "EXECUTANDO BENCHMARK #2 - HILL CLIMBING"
mix run benchmarks/hill_climbing/example_2.exs
echo "EXECUTANDO BENCHMARK #3 - HILL CLIMBING"
mix run benchmarks/hill_climbing/example_3.exs
echo "EXECUTANDO BENCHMARK #4 - HILL CLIMBING"
mix run benchmarks/hill_climbing/example_4.exs

echo "EXECUTANDO BENCHMARK #1 - ITERATED LOCAL SEARCH"
mix run benchmarks/ils/example_1.exs
echo "EXECUTANDO BENCHMARK #2 - ITERATED LOCAL SEARCH"
mix run benchmarks/ils/example_2.exs
echo "EXECUTANDO BENCHMARK #3 - ITERATED LOCAL SEARCH"
mix run benchmarks/ils/example_3.exs
echo "EXECUTANDO BENCHMARK #4 - ITERATED LOCAL SEARCH"
mix run benchmarks/ils/example_4.exs