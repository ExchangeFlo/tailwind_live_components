defmodule TailwindComponents.MixProject do
  use Mix.Project

  @source_url "https://github.com/rocketinsights/tailwind_components"
  @version "0.1.0"

  def project do
    [
      app: :tailwind_components,
      version: @version,
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs()
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
      {:phoenix, "~> 1.6"},
      {:phoenix_live_view, "~> 0.17"},
      {:jason, "~> 1.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:phoenix_ecto, "~> 4.4", only: :test}
    ]
  end

  defp description() do
    """
    Tailwind Components is a set of HEEX components that builds LiveView components with Tailwind 3.0
    """
  end

  defp package do
    [
      maintainers: ["Jon Principe"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs() do
    [
      main: "readme",
      logo: "logo.png",
      name: "Tailwind Components",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/tailwind_components",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
