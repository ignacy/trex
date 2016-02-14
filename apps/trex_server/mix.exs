defmodule TrexServer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :trex_server,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [
      applications: [:logger, :trex_storage],
      mod: {TrexServer, []}
    ]
  end

  defp deps do
    [{:trex_storage, in_umbrella: true}]
  end
end
