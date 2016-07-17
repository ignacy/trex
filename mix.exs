defmodule Trex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :trex,
      version: "0.5.1",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps
    ]
  end

  def application do
    [
      applications: [:logger, :amnesia, :ranch],
      mod: {Trex, []}
    ]
  end

  defp deps do
    [
      {:amnesia, "~> 0.2.0", github: "meh/amnesia"},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:exrm, "~> 1.0.6"},
      {:ranch, "~> 1.2.1"}
    ]
  end

  defp description do
    """
    Trex is a key value store implementing a subset of Redis protocol,
    designed to be suitable as a Rails I18n backend.
    """
  end

  defp package do
    [
      name: :trex,
      maintainers: ["Michał Darda", "Ignacy Moryc"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/ignacy/trex" }
    ]
  end
end
