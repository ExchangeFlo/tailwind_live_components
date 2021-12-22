defmodule TailwindLiveComponents.MixProject do
  use Mix.Project

  @source_url "https://github.com/sourceflo/tailwind_live_components"
  @version "0.1.3"

  def project do
    [
      app: :tailwind_live_components,
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:jason, "~> 1.0", only: [:dev, :test]},
      {:heroicons_liveview, "~> 0.4.0"},
      {:number, "~> 1.0"},
      {:phoenix, "~> 1.6"},
      {:phoenix_live_view, "~> 0.17"},
      {:phoenix_ecto, "~> 4.4", only: :test}
    ]
  end

  defp description() do
    """
    Tailwind Live Components is a set of HEEX components that builds LiveView components with Tailwind 2.0+
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
      name: "Tailwind Live Components",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/tailwind_live_components",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
