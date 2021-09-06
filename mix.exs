defmodule Meta.MixProject do
  use Mix.Project

  def project do
    [
      app: :code,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      name: "TP I",
      source_url: "https://github.com/gfviegas/meta-hc-ils",
      homepage_url: "https://gfviegas.github.io/meta-hc-ils",
      docs: [
        # The main page in the docs
        main: "readme",
        extras: ["README.md", "benchmarks.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:math, "~> 0.6.0"},
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end
end
