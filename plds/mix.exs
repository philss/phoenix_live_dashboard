defmodule PLDS.MixProject do
  use Mix.Project

  def project do
    [
      app: :plds,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      escript: escript(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PLDS.Application, []},
      env: [phoenix: [json_library: Jason]]
    ]
  end

  defp aliases do
    [
      # TODO: loadconfig no longer required on Elixir v1.13
      # Currently this ensures we load configuration before
      # compiling dependencies as part of `mix escript.install`.
      # See https://github.com/elixir-lang/elixir/commit/a6eefb244b3a5892895a97b2dad4cce2b3c3c5ed
      "escript.build": ["loadconfig", "escript.build"]
    ]
  end

  defp escript do
    [
      main_module: PLDS,
      app: nil
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.5.9"},
      {:jason, ">= 0.0.0"},
      {:phoenix_live_dashboard, "~> 0.5.0"}
    ]
  end
end
