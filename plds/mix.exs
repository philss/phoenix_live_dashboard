defmodule PLDS.MixProject do
  use Mix.Project

  def project do
    [
      app: :plds,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      escript: escript(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PLDS.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.10"},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:telemetry_metrics, "~> 0.4"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      # TODO: loadconfig no longer required on Elixir v1.13
      # Currently this ensures we load configuration before
      # compiling dependencies as part of `mix escript.install`.
      # See https://github.com/elixir-lang/elixir/commit/a6eefb244b3a5892895a97b2dad4cce2b3c3c5ed
      "escript.build": ["loadconfig", "escript.build"],
      setup: ["deps.get"]
    ]
  end

  defp escript do
    [
      main_module: PLDS,
      app: nil
    ]
  end
end
