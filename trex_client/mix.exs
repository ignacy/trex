defmodule TrexClient.Mixfile do
  use Mix.Project

  def project do
    [app: :trex_client,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     escript: [main_module: TrexClient]]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end
end
