defmodule Metrex.Mixfile do
  use Mix.Project

  def project do
    [app: :metrex,
     version: "0.2.0",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps,
     docs: [extras: ["README.md"]]]
  end

  def application do
    [applications: [:logger],
     mod: {Metrex, []}]
  end

  defp deps do
    [{:ex_doc, "~> 0.13.0", only: :dev}, {:credo, "~> 0.4.12", only: :dev}]
  end

  defp description do
    """
    Simple metrics for elixir apps
    """
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp package do
    [name: :metrex,
     files: ["lib", "mix.exs", "README.md"],
     maintainers: ["Mustafa Turan"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mustafaturan/metrex"}]
  end
end
