defmodule TrexCLI.Mixfile do
  use Mix.Project

  def project do
    [app: :trex_cli,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     escript: [main_module: TrexCLI]]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end
end
