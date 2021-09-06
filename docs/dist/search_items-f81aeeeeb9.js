searchNodes=[{"doc":"Describes a collection of useful benchmark problems. A simple example is provided in simple_example/1 to serve as a starting point to meta-heuristics testing. There is also example_one/2 and example_two/2 to provide harder problems in a multimodal environment.","ref":"Meta.Functions.html","title":"Meta.Functions","type":"module"},{"doc":"A multimodal function.","ref":"Meta.Functions.html#example_one/2","title":"Meta.Functions.example_one/2","type":"function"},{"doc":"A multimodal function.","ref":"Meta.Functions.html#example_two/2","title":"Meta.Functions.example_two/2","type":"function"},{"doc":"A simple x^2 function.","ref":"Meta.Functions.html#simple_example/1","title":"Meta.Functions.simple_example/1","type":"function"},{"doc":"Attempt to find a local maximum/minimum value using HillClimbing. It uses a GenServer and self-sending callback messages to loop through the heuristic iterations until a finish cryteria is reached. The implemented cryterias are: max_iterations : The maximum amount of allowed callback messages sent to a hillclimb iteration; max_consecutive_no_progress_iterations : The maximum amount of consecutive hillclimb iterations without a improvement in the solution;","ref":"Meta.HillClimbing.Solver.html","title":"Meta.HillClimbing.Solver","type":"module"},{"doc":"Returns a specification to start this module under a supervisor. See Supervisor .","ref":"Meta.HillClimbing.Solver.html#child_spec/1","title":"Meta.HillClimbing.Solver.child_spec/1","type":"function"},{"doc":"Generates a HillClimbing GenServer process to solve the problem. Return values If the server is successfully created and initialized, this function returns {:ok, pid} , where pid is the PID of the server. If a process with the specified server name already exists, this function returns {:error, {:already_started, pid}} with the PID of that process. If the GenServer:init/1 callback fails with reason, this function returns {:error, reason} . Otherwise, if it returns {:stop, reason} or :ignore , the process is terminated and this function returns { :error, reason} or :ignore , respectively. Examples iex&gt; options = [ problem : % Meta.Problem { objective : &amp; Meta.Functions . simple_example / 1 , variables : [ % Meta.Problem.Variable { name : :x , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 10 } } ] , } , noise_sizes : [ x : 0.25 ] , max_iterations : 200 , max_consecutive_no_progress_iterations : 50 ] iex&gt; Meta.HillClimbing.Solver . setup ( opts ) { :ok , # PID &lt; &gt; }","ref":"Meta.HillClimbing.Solver.html#setup/1","title":"Meta.HillClimbing.Solver.setup/1","type":"function"},{"doc":"Solves for HillClimbing the problem configured in the provided pid server. Logs Useful logs are used with the Logger module, regarding info of the iteration index and the solution found at that index. It is also logged when the process is finished and which cryteria was used to terminate the execution: 15 : 28 : 26.504 mfa = Meta.HillClimbing.Solver . handle_continue / 2 [ info ] Solution #1: %Meta.Problem.Solution{value: 51.660402502492126, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 7.187517130587733}]} 15 : 28 : 26.504 mfa = Meta.HillClimbing.Solver . handle_continue / 2 [ info ] Solution #2: %Meta.Problem.Solution{value: 80.21040204576592, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 8.956026018595855}]} 15 : 28 : 26.504 mfa = Meta.HillClimbing.Solver . handle_continue / 2 [ info ] Solution #3: %Meta.Problem.Solution{value: 49.492197212573195, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 7.035069097924568}]} ... 15 : 28 : 26.529 mfa = Meta.HillClimbing.Solver . handle_continue / 2 [ info ] Solution #197: %Meta.Problem.Solution{value: 6.841908964815985e-11, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 8.271583261272285e-6}]} 15 : 28 : 26.529 mfa = Meta.HillClimbing.Solver . handle_continue / 2 [ info ] Solution #198: %Meta.Problem.Solution{value: 4.2071463961827206e-11, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 6.4862519193928325e-6}]} 15 : 28 : 26.529 mfa = Meta.HillClimbing.Solver . handle_continue / 2 [ info ] Solution #199: %Meta.Problem.Solution{value: 5.924935935911621e-11, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 7.697360544960604e-6}]} 15 : 28 : 26.529 mfa = Meta.HillClimbing.Solver . handle_continue / 2 [ info ] Process finished by reason : &#39;Maximum iterations reached: 200&#39; ! Return values A Meta.Problem.Solution is yielded when the process converges. Examples iex&gt; options = [ problem : % Meta.Problem { objective : &amp; Meta.Functions . simple_example / 1 , variables : [ % Meta.Problem.Variable { name : :x , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 10 } } ] , } , noise_sizes : [ x : 0.25 ] , max_iterations : 200 , max_consecutive_no_progress_iterations : 50 ] iex&gt; { :ok , pid } = Meta.HillClimbing.Solver . setup ( opts ) iex&gt; Meta.HillClimbing.Solver . solve ( pid ) % Meta.Problem.Solution { value : 4.2071463961827206e-11 , variables : [ % Meta.Problem.Variable { constraint : % Meta.Problem.Constraint { higher_boundary : 10 , lower_boundary : 0 } , name : :x , value : 6.4862519193928325e-6 } ] }","ref":"Meta.HillClimbing.Solver.html#solve/1","title":"Meta.HillClimbing.Solver.solve/1","type":"function"},{"doc":"Describes a Genserver State for a HillClimbing run","ref":"Meta.HillClimbing.State.html","title":"Meta.HillClimbing.State","type":"module"},{"doc":"","ref":"Meta.HillClimbing.State.html#t:t/0","title":"Meta.HillClimbing.State.t/0","type":"type"},{"doc":"Attempt to find a local maximum/minimum value using ILS and HillClimbing as a local searcher. It uses a GenServer and self-sending callback messages to loop through the heuristic iterations until a finish cryteria is reached. The implemented cryterias are: max_iterations : The maximum amount of allowed callback messages sent to a hillclimb iteration; max_consecutive_no_progress_iterations : The maximum amount of consecutive hillclimb iterations without a improvement in the solution;","ref":"Meta.IteratedLocalSearch.Solver.html","title":"Meta.IteratedLocalSearch.Solver","type":"module"},{"doc":"Returns a specification to start this module under a supervisor. See Supervisor .","ref":"Meta.IteratedLocalSearch.Solver.html#child_spec/1","title":"Meta.IteratedLocalSearch.Solver.child_spec/1","type":"function"},{"doc":"Generates a IteratedLocalSearch GenServer process to solve the problem. Return values If the server is successfully created and initialized, this function returns {:ok, pid} , where pid is the PID of the server. If a process with the specified server name already exists, this function returns {:error, {:already_started, pid}} with the PID of that process. If the GenServer:init/1 callback fails with reason, this function returns {:error, reason} . Otherwise, if it returns {:stop, reason} or :ignore , the process is terminated and this function returns { :error, reason} or :ignore , respectively. Examples iex&gt; options = [ problem : % Meta.Problem { objective : &amp; Meta.Functions . example_one / 2 , variables : [ % Meta.Problem.Variable { name : :x , constraint : % Meta.Problem.Constraint { lower_boundary : - 1.5 , higher_boundary : 4 } } , % Meta.Problem.Variable { name : :y , constraint : % Meta.Problem.Constraint { lower_boundary : - 3 , higher_boundary : 4 } } ] , } , hc_options : [ noise_sizes : [ x : 0.25 , y : 0.25 ] , max_iterations : 200 , max_consecutive_no_progress_iterations : 2 ] , pertubation_size : 0.5 , max_iterations : 200 , max_consecutive_no_progress_iterations : 50 ] iex&gt; Meta.IteratedLocalSearch.Solver . setup ( opts ) { :ok , # PID &lt; &gt; }","ref":"Meta.IteratedLocalSearch.Solver.html#setup/1","title":"Meta.IteratedLocalSearch.Solver.setup/1","type":"function"},{"doc":"Solves for IteratedLocalSearch the problem configured in the provided pid server. Logs Useful logs are used with the Logger module, regarding info of the iteration index and the solution found at that index. It is also logged when the process is finished and which cryteria was used to terminate the execution: 15 : 28 : 26.504 mfa = Meta.IteratedLocalSearch.Solver . handle_continue / 2 [ info ] Solution #1: %Meta.Problem.Solution{value: 51.660402502492126, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 7.187517130587733}]} 15 : 28 : 26.504 mfa = Meta.IteratedLocalSearch.Solver . handle_continue / 2 [ info ] Solution #2: %Meta.Problem.Solution{value: 80.21040204576592, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 8.956026018595855}]} 15 : 28 : 26.504 mfa = Meta.IteratedLocalSearch.Solver . handle_continue / 2 [ info ] Solution #3: %Meta.Problem.Solution{value: 49.492197212573195, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 7.035069097924568}]} ... 15 : 28 : 26.529 mfa = Meta.IteratedLocalSearch.Solver . handle_continue / 2 [ info ] Solution #197: %Meta.Problem.Solution{value: 6.841908964815985e-11, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 8.271583261272285e-6}]} 15 : 28 : 26.529 mfa = Meta.IteratedLocalSearch.Solver . handle_continue / 2 [ info ] Solution #198: %Meta.Problem.Solution{value: 4.2071463961827206e-11, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 6.4862519193928325e-6}]} 15 : 28 : 26.529 mfa = Meta.IteratedLocalSearch.Solver . handle_continue / 2 [ info ] Solution #199: %Meta.Problem.Solution{value: 5.924935935911621e-11, variables: [%Meta.Problem.Variable{constraint: %Meta.Problem.Constraint{higher_boundary: 10, lower_boundary: 0}, name: :x, value: 7.697360544960604e-6}]} 15 : 28 : 26.529 mfa = Meta.IteratedLocalSearch.Solver . handle_continue / 2 [ info ] Process finished by reason : &#39;Maximum iterations reached: 200&#39; ! Return values A Meta.Problem.Solution is yielded when the process converges. Examples iex&gt; options = [ problem : % Meta.Problem { objective : &amp; Meta.Functions . example_one / 2 , variables : [ % Meta.Problem.Variable { name : :x , constraint : % Meta.Problem.Constraint { lower_boundary : - 1.5 , higher_boundary : 4 } } , % Meta.Problem.Variable { name : :y , constraint : % Meta.Problem.Constraint { lower_boundary : - 3 , higher_boundary : 4 } } ] , } , hc_options : [ noise_sizes : [ x : 0.25 , y : 0.25 ] , max_iterations : 200 , max_consecutive_no_progress_iterations : 2 ] , pertubation_size : 0.5 , max_iterations : 200 , max_consecutive_no_progress_iterations : 50 ] iex&gt; { :ok , pid } = Meta.IteratedLocalSearch.Solver . setup ( opts ) iex&gt; Meta.IteratedLocalSearch.Solver . solve ( pid ) % Meta.Problem.Solution { value : 4.2071463961827206e-11 , variables : [ % Meta.Problem.Variable { constraint : % Meta.Problem.Constraint { higher_boundary : 10 , lower_boundary : 0 } , name : :x , value : 6.4862519193928325e-6 } ] }","ref":"Meta.IteratedLocalSearch.Solver.html#solve/1","title":"Meta.IteratedLocalSearch.Solver.solve/1","type":"function"},{"doc":"Definition of an arbitrary optimization problem to be solved using meta-heuristics. To use a problem definition you must provide the variables list and the objective function. The objective arity must match the variables length and must be placed in a sorted order as the function must be called. This module also acknowledges some common functions around Problem solving.","ref":"Meta.Problem.html","title":"Meta.Problem","type":"module"},{"doc":"Applies the objective function with variables and yields a Solution struct with the function result and the variables used, useful for logging or history registry. # Examples iex&gt; fetch_solution ( &amp; Meta.Functions . simple_example / 1 , [ % Meta.Problem.Variable { name : :x , value : 3 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } ] ) % Meta.Problem.Solution { value : 9 , variables : [ % Meta.Problem.Variable { name : :x , value : 3 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } ] } iex&gt; fetch_solution ( &amp; Meta.Functions . example_one / 2 , [ % Meta.Problem.Variable { name : :x , value : 10 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } , % Meta.Problem.Variable { name : :y , value : 4 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } ] ) % Meta.Problem.Solution { value : 32.99060735569487 , variables : [ % Meta.Problem.Variable { name : :x , value : 10 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } , % Meta.Problem.Variable { name : :y , value : 4 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } ] }","ref":"Meta.Problem.html#fetch_solution/2","title":"Meta.Problem.fetch_solution/2","type":"function"},{"doc":"Compares two solutions and returns if the first is better than the second, based on the problem's type ( :minimization or :maximization ). # Examples iex&gt; is_better? ( % Meta.Problem.Solution { value : 2 , variables : [ ] } , % Meta.Problem.Solution { value : 1 , variables : [ ] } , :minimization ) false iex&gt; is_better? ( % Meta.Problem.Solution { value : 2 , variables : [ ] } , % Meta.Problem.Solution { value : 1 , variables : [ ] } , :maximization ) true","ref":"Meta.Problem.html#is_better?/3","title":"Meta.Problem.is_better?/3","type":"function"},{"doc":"Seeds a variable value field if its nil, generating a random variable value respecting its constraint definitions. If the variable already has a value, nothing is changed, hence the maybe name. # Examples iex&gt; :rand . seed ( :exsplus , { 101 , 102 , 103 } ) iex&gt; maybe_generate_random_variable_value ( % Meta.Problem.Variable { name : :x , value : nil , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } ) % Meta.Problem.Variable { name : :x , value : 1.489738081165117 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } iex&gt; maybe_generate_random_variable_value ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } ) % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } }","ref":"Meta.Problem.html#maybe_generate_random_variable_value/1","title":"Meta.Problem.maybe_generate_random_variable_value/1","type":"function"},{"doc":"Tweak a variable value, to a maximum of a matching variable name in noise_sizes . The constraints of the variable are respected, so the maximum delta change may be lower than the noise_size found. The variable is only tweaked if a probability check passes (a random float between 0 and 1 is lower than the probability argument). It raises an Error if the probability is not between 0 and 1 # Examples iex&gt; :rand . seed ( :exsplus , { 101 , 102 , 103 } ) iex&gt; maybe_tweak_variable ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } , 1 , [ x : 0.25 ] ) % Meta.Problem.Variable { name : :x , value : 0.978631679333307 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } iex&gt; maybe_tweak_variable ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } , 0 , [ x : 0.25 ] ) % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } iex&gt; :rand . seed ( :exsplus , { 101 , 102 , 103 } ) iex&gt; maybe_tweak_variable ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } , 1 , [ x : 5000 ] ) % Meta.Problem.Variable { name : :x , value : 0.9145267173332277 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } }","ref":"Meta.Problem.html#maybe_tweak_variable/3","title":"Meta.Problem.maybe_tweak_variable/3","type":"function"},{"doc":"Flattens a solution map to a one-dimensional for serialiation purpose. The key value of solution is passed on along each variable name as key and its corresponding values as value. Examples iex&gt; serialize ( % Meta.Problem.Solution { value : 5 , variables : [ % Meta.Problem.Variable { name : :x , value : 0.25 } , % Meta.Problem.Variable { name : :y , value : 0.5 } ] } ) %{ value : 5 , x : 0.25 , y : 0.5 }","ref":"Meta.Problem.html#serialize/1","title":"Meta.Problem.serialize/1","type":"function"},{"doc":"Tweak a variable value, to a maximum of a noise_size . The constraints of the variable are respected, so the maximum delta change may be lower than the noise_size found. # Examples iex&gt; :rand . seed ( :exsplus , { 101 , 102 , 103 } ) iex&gt; tweak_variable ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } , 0.25 ) % Meta.Problem.Variable { name : :x , value : 1.1224345202912793 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } iex&gt; :rand . seed ( :exsplus , { 101 , 102 , 103 } ) iex&gt; tweak_variable ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } , 5000 ) % Meta.Problem.Variable { name : :x , value : 1.489738081165117 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } }","ref":"Meta.Problem.html#tweak_variable/2","title":"Meta.Problem.tweak_variable/2","type":"function"},{"doc":"","ref":"Meta.Problem.html#t:t/0","title":"Meta.Problem.t/0","type":"type"},{"doc":"Definition of an arbitrary variable constraints.","ref":"Meta.Problem.Constraint.html","title":"Meta.Problem.Constraint","type":"module"},{"doc":"","ref":"Meta.Problem.Constraint.html#t:t/0","title":"Meta.Problem.Constraint.t/0","type":"type"},{"doc":"Definition of an arbitrary problem solution. The variables is useful for knowing exactly the parameters used to generate the value .","ref":"Meta.Problem.Solution.html","title":"Meta.Problem.Solution","type":"module"},{"doc":"","ref":"Meta.Problem.Solution.html#t:t/0","title":"Meta.Problem.Solution.t/0","type":"type"},{"doc":"Definition of an arbitrary problem variable. The name is used in problem-solving meta-heuristics algorithms and the constraint key is used to respect the boundaries of a problem.","ref":"Meta.Problem.Variable.html","title":"Meta.Problem.Variable","type":"module"},{"doc":"","ref":"Meta.Problem.Variable.html#t:t/0","title":"Meta.Problem.Variable.t/0","type":"type"},{"doc":"HC and ILS solver This project is an academic implementation of both HillClimbing (HC) and Iterated Local Search (ILS) for meta-heuristics learning purposes. Both heuristics benefits from shared Meta.Problem module and it's inner types. Benchmarks were conducted using the Meta.Functions.example_one and Meta.Functions.example_two equations and more info is provided in the Benchmarks Page . Full Documentation","ref":"readme.html","title":"HC and ILS solver","type":"extras"},{"doc":"The algorithms were implemented using the Elixir language in a Mix project environment and ex-docs documentation and an ExUnit testing framework. All code source is open-source in the github repository . Also the API Reference displays all kind of details in modules and structs implemented, as well as the module doc tests. Overall, the problems were implemented in a pure functional fashion using a GenServer and messages-to-self process for quick iteration and control over implementation. More details in the modules docs.","ref":"readme.html#code-implementation-details","title":"HC and ILS solver - Code Implementation Details","type":"extras"},{"doc":"A Dockerfile and docker-compose.yml files is provided in this project for quick setup and run: docker-compose run tp1 The default entrypoint is the running of all benchmarks problems, which can then be further analysed in the benchmarks/analysis.ipynb notebook. Full Documentation Generating Docs With the Docker environment, to generate a docs folder with the ExDoc files is easy as docker-compose run tp1 mix docs --output docs Testing Automated test is also implemented in moduledocs test, and can be run with the command below: docker-compose run tp1 mix test Which will yield a result close to the one below: root@99e6f88b669d:/code# mix test Compiling 10 files (.ex) Generated code app ............ Finished in 0.05 seconds (0.05s async, 0.00s sync) 12 doctests, 0 failures","ref":"readme.html#running","title":"HC and ILS solver - Running","type":"extras"},{"doc":"Benchmarks This page provides the benchmark results for two multimodals problems, running in two different constraints setup and with both ILS and HC algorithms.","ref":"benchmarks.html","title":"Benchmarks","type":"extras"},{"doc":"This benchmark problem uses the Meta.Functions.example_one function, also shown in the image below. 30 individual runs was executed under two different setups: Configuration 1.a with more relaxed variable constraints and Configuration 1.b with a less relaxed constraints. Configuration 1.a This setting had the following constraints on variables: −1.5 ≤ 𝑥 ≤ 4 −3 ≤ 𝑦 ≤ 4 Hill Climbing Parameters Noise size (step size): 0.25 for both variables Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 200 Max consecutive iterations without improvements allowed: 50 Iterated Local Search Parameters Perturbation size (step size): 0.5 Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 200 Max consecutive iterations without improvements allowed: 50 Local search algorithm: Hill Climbing, with: Noise size (step size): 0.25 for both variables Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 200 Max consecutive iterations without improvements allowed: 2 Results and Discussion The 30 independent individual executions results ran is shown in the table below: Algorithm Minimum Maximum Mean Average Std. Deviation HC -1.913115 1.240485 -0.264049 1.436836 ILS -1.910092 1.510261 0.433561 1.215818 The boxplot for both executions is also shown in the image below: The results shows a good overall performance by HC since it's variety is not as good as the ILS. Since the ILS algorithms tends to change its attraction roundabouts, the mean average its way poorer, but the minum value found, hence the best overall result, is better than the one found in the HC. For overall experience of the author, these stats is not the preferable choices, since the random pattern behaviour of both approaches tends to have outliers that never leaves its local minimums/maximums. A good statistical choice would be the median and/or the median average deviation instead of the mean and standard deivation. The results overall, are expected, but a little too far off the mean average for ILS, which suggests a perturbation size not optimal, that was choice empiracally and not changed for academic results. Configuration 1.b This setting had the following constraints on variables: −1 ≤ 𝑥 ≤ 0 −2 ≤ 𝑦 ≤ 1 Hill Climbing Parameters Noise size (step size): 0.25 for both variables Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 200 Max consecutive iterations without improvements allowed: 50 Iterated Local Search Parameters Perturbation size (step size): 0.5 Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 200 Max consecutive iterations without improvements allowed: 50 Local search algorithm: Hill Climbing, with: Noise size (step size): 0.25 for both variables Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 200 Max consecutive iterations without improvements allowed: 2 Results and Discussion The 30 independent individual executions results ran is shown in the table below: Algorithm Minimum Maximum Mean Average Std. Deviation HC -1.913168 -1.906510 -1.912136 0.001312 ILS -1.913215 -1.910281 -1.912661 0.000619 The boxplot for both executions is also shown in the image below: The results shows a better mean average, minimum and maximum result for ILS as it's expected, since the randomness is reduced in a smaller search space and also tends to converge faster in a more robust environment. Nothing too particular to note here, just that ILS is a better approach towards these kind of algorithms than HC alone, as we can see in the results table and boxplot.","ref":"benchmarks.html#benchmark-1","title":"Benchmarks - Benchmark 1","type":"extras"},{"doc":"This benchmark problem uses the Meta.Functions.example_two function, also shown in the image below. 30 individual runs was executed under two different setups: Configuration 2.a with more relaxed variable constraints and Configuration 2.b with a less relaxed constraints. Configuration 2.a This setting had the following constraints on variables: −512 ≤ 𝑥 ≤ 512 −512 ≤ 𝑦 ≤ 512 Hill Climbing Parameters Noise size (step size): 0.25 for both variables Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 500 Max consecutive iterations without improvements allowed: 50 Iterated Local Search Parameters Perturbation size (step size): 0.5 Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 200 Max consecutive iterations without improvements allowed: 50 Local search algorithm: Hill Climbing, with: Noise size (step size): 0.25 for both variables Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 200 Max consecutive iterations without improvements allowed: 2 Results and Discussion The 30 independent individual executions results ran is shown in the table below: Algorithm Minimum Maximum Mean Average Std. Deviation HC -948.285209 -110.811574 -507.114183 245.121166 ILS -923.058723 -200.301893 -571.793068 191.732634 The boxplot for both executions is also shown in the image below: This is where ILS tends to shine brighter! The harder the problem, the better are the results. ILS tops HC in almost all aspects, specially in std deviation, which suggests less randomness than HC, and a best minimum performance by HC suggests just a bare luck in picking a specially good attraction area by randomness since the maximum and std deviation lacks so much from the ILS runs. Configuration 2.b This setting had the following constraints on variables: −511 ≤ 𝑥 ≤ 512 -404 ≤ 𝑦 ≤ 405 Hill Climbing Parameters Noise size (step size): 0.25 for both variables Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 500 Max consecutive iterations without improvements allowed: 50 Iterated Local Search Parameters Perturbation size (step size): 0.5 Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 200 Max consecutive iterations without improvements allowed: 50 Local search algorithm: Hill Climbing, with: Noise size (step size): 0.25 for both variables Stop cyteria: max iterations or max consecutives iterations without improvements Max iterations allowed: 200 Max consecutive iterations without improvements allowed: 2 Results and Discussion The 30 independent individual executions results ran is shown in the table below: Algorithm Minimum Maximum Mean Average Std. Deviation HC -959.631515 -959.388812 -959.552555 0.067009 ILS -959.636417 -959.517764 -959.601634 0.026641 The boxplot for both executions is also shown in the image below: Although really near the HC results, ILS performes better in every aspects measured. It is known a smaller search space tends to prevent early convergence for both approaches, but ILS is specially better in the std. deviation results in this benchakrk, which is somehow odd since the smaller search space tends to benefit the HC algorithm as the local minimum values probability to be the global minimum one in the domain is way better. Yet again, a better std. deviation result for ILS compared to HC in this benchmark tends to show the 2.a parameters could be better tuned to favor ILS, as its way more powerful than HC alone but yet has closer or even worse results depending on the way you see it.","ref":"benchmarks.html#benchmark-2","title":"Benchmarks - Benchmark 2","type":"extras"}]