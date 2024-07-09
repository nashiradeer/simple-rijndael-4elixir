defmodule SimpleRijndael.MixProject do
  use Mix.Project

  def project do
    [
      app: :simple_rijndael,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
       {:rustler, "~> 0.33.0", runtime: false}
    ]
  end
end
