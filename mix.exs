defmodule Trex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :trex,
      version: "0.0.1",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [
      applications: [:logger],
      mod: {Trex, []}
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:amnesia, "~> 0.2.0", github: "meh/amnesia"}
    ]
  end
end
