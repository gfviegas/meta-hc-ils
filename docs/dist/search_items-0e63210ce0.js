searchNodes=[{"doc":"Describes a collection of useful benchmark problems. A simple example is provided in simple_example/1 to serve as a starting point to meta-heuristics testing. There is also example_one/2 and example_two/2 to provide harder problems in a multimodal environment.","ref":"Meta.Functions.html","title":"Meta.Functions","type":"module"},{"doc":"A multimodal function, see the main page for more`.","ref":"Meta.Functions.html#example_one/2","title":"Meta.Functions.example_one/2","type":"function"},{"doc":"A multimodal function, see the main page for more`.","ref":"Meta.Functions.html#example_two/2","title":"Meta.Functions.example_two/2","type":"function"},{"doc":"A simple x^2 function.","ref":"Meta.Functions.html#simple_example/1","title":"Meta.Functions.simple_example/1","type":"function"},{"doc":"","ref":"Meta.IteratedLocalSearch.State.HillClimbingOptions.html","title":"Meta.IteratedLocalSearch.State.HillClimbingOptions","type":"module"},{"doc":"Definition of an arbitrary optimization problem to be solved using meta-heuristics. To use a problem definition you must provide the variables list and the objective function. The objective arity must match the variables length and must be placed in a sorted order as the function must be called. This module also acknowledges some common functions around Problem solving.","ref":"Meta.Problem.html","title":"Meta.Problem","type":"module"},{"doc":"Applies the objective function with variables and yields a Solution struct with the function result and the variables used, useful for logging or history registry. # Examples iex&gt; fetch_solution ( &amp; Meta.Functions . simple_example / 1 , [ % Meta.Problem.Variable { name : :x , value : 3 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } ] ) % Meta.Problem.Solution { value : 9 , variables : [ % Meta.Problem.Variable { name : :x , value : 3 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } ] } iex&gt; fetch_solution ( &amp; Meta.Functions . example_one / 2 , [ % Meta.Problem.Variable { name : :x , value : 10 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } , % Meta.Problem.Variable { name : :y , value : 4 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } ] ) % Meta.Problem.Solution { value : 32.99060735569487 , variables : [ % Meta.Problem.Variable { name : :x , value : 10 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } , % Meta.Problem.Variable { name : :y , value : 4 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 100 } } ] }","ref":"Meta.Problem.html#fetch_solution/2","title":"Meta.Problem.fetch_solution/2","type":"function"},{"doc":"Compares two solutions and returns if the first is better than the second, based on the problem's type ( :minimization or :maximization ). # Examples iex&gt; is_better? ( % Meta.Problem.Solution { value : 2 , variables : [ ] } , % Meta.Problem.Solution { value : 1 , variables : [ ] } , :minimization ) false iex&gt; is_better? ( % Meta.Problem.Solution { value : 2 , variables : [ ] } , % Meta.Problem.Solution { value : 1 , variables : [ ] } , :maximization ) true","ref":"Meta.Problem.html#is_better?/3","title":"Meta.Problem.is_better?/3","type":"function"},{"doc":"Seeds a variable value field if its nil, generating a random variable value respecting its constraint definitions. If the variable already has a value, nothing is changed, hence the maybe name. # Examples iex&gt; :rand . seed ( :exsplus , { 101 , 102 , 103 } ) iex&gt; maybe_generate_random_variable_value ( % Meta.Problem.Variable { name : :x , value : nil , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } ) % Meta.Problem.Variable { name : :x , value : 1.489738081165117 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } iex&gt; maybe_generate_random_variable_value ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } ) % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } }","ref":"Meta.Problem.html#maybe_generate_random_variable_value/1","title":"Meta.Problem.maybe_generate_random_variable_value/1","type":"function"},{"doc":"Tweak a variable value, to a maximum of a matching variable name in noise_sizes . The constraints of the variable are respected, so the maximum delta change may be lower than the noise_size found. The variable is only tweaked if a probability check passes (a random float between 0 and 1 is lower than the probability argument). It raises an Error if the probability is not between 0 and 1 # Examples iex&gt; :rand . seed ( :exsplus , { 101 , 102 , 103 } ) iex&gt; maybe_tweak_variable ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } , 1 , [ x : 0.25 ] ) % Meta.Problem.Variable { name : :x , value : 0.978631679333307 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } iex&gt; maybe_tweak_variable ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } , 0 , [ x : 0.25 ] ) % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } iex&gt; :rand . seed ( :exsplus , { 101 , 102 , 103 } ) iex&gt; maybe_tweak_variable ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } , 1 , [ x : 5000 ] ) % Meta.Problem.Variable { name : :x , value : 0.9145267173332277 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } }","ref":"Meta.Problem.html#maybe_tweak_variable/3","title":"Meta.Problem.maybe_tweak_variable/3","type":"function"},{"doc":"Flattens a solution map to a one-dimensional for serialiation purpose. The key value of solution is passed on along each variable name as key and its corresponding values as value. Examples iex&gt; serialize ( % Meta.Problem.Solution { value : 5 , variables : [ % Meta.Problem.Variable { name : :x , value : 0.25 } , % Meta.Problem.Variable { name : :y , value : 0.5 } ] } ) %{ value : 5 , x : 0.25 , y : 0.5 }","ref":"Meta.Problem.html#serialize/1","title":"Meta.Problem.serialize/1","type":"function"},{"doc":"Tweak a variable value, to a maximum of a noise_size . The constraints of the variable are respected, so the maximum delta change may be lower than the noise_size found. # Examples iex&gt; :rand . seed ( :exsplus , { 101 , 102 , 103 } ) iex&gt; tweak_variable ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } , 0.25 ) % Meta.Problem.Variable { name : :x , value : 1.1224345202912793 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } iex&gt; :rand . seed ( :exsplus , { 101 , 102 , 103 } ) iex&gt; tweak_variable ( % Meta.Problem.Variable { name : :x , value : 1 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } } , 5000 ) % Meta.Problem.Variable { name : :x , value : 1.489738081165117 , constraint : % Meta.Problem.Constraint { lower_boundary : 0 , higher_boundary : 2 } }","ref":"Meta.Problem.html#tweak_variable/2","title":"Meta.Problem.tweak_variable/2","type":"function"},{"doc":"","ref":"Meta.Problem.html#t:t/0","title":"Meta.Problem.t/0","type":"type"},{"doc":"","ref":"Meta.Problem.Constraint.html","title":"Meta.Problem.Constraint","type":"module"},{"doc":"","ref":"Meta.Problem.Constraint.html#t:t/0","title":"Meta.Problem.Constraint.t/0","type":"type"},{"doc":"","ref":"Meta.Problem.Solution.html","title":"Meta.Problem.Solution","type":"module"},{"doc":"","ref":"Meta.Problem.Solution.html#t:t/0","title":"Meta.Problem.Solution.t/0","type":"type"},{"doc":"Definition of an arbitrary problem variable. The name is used in problem-solving meta-heuristics algorithms and the constraint key is used to respect the boundaries of a problem.","ref":"Meta.Problem.Variable.html","title":"Meta.Problem.Variable","type":"module"},{"doc":"","ref":"Meta.Problem.Variable.html#t:t/0","title":"Meta.Problem.Variable.t/0","type":"type"},{"doc":"Meta TODO: Add description","ref":"readme.html","title":"Meta","type":"extras"},{"doc":"If available in Hex , the package can be installed by adding code to your list of dependencies in mix.exs : def deps do [ { :code , &quot;~&gt; 0.1.0&quot; } ] end Documentation can be generated with ExDoc and published on HexDocs . Once published, the docs can be found at https://hexdocs.pm/code .","ref":"readme.html#installation","title":"Meta - Installation","type":"extras"}]