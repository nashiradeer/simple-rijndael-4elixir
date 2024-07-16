defmodule SimpleRijndael.MixProject do
  use Mix.Project

  @source_url "https://github.com/nashiradeer/simple-rijndael-4elixir"
  @version "0.1.0"

  def project do
    [
      app: :simple_rijndael,
      name: "SimpleRijndael",
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger, :eex]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:rustler, "~> 0.34.0", runtime: false}
    ]
  end

  defp package do
    [
      description: "A simple Rijndael implementation for Elixir.",
      files: ["lib", "mix.exs", "README.md", "LICENSE.txt", "native", "test"],
      maintainers: ["Nashira Deer"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/nashiradeer/simple-rijndael-4elixir"
      }
    ]
  end

  defp docs do
    [
      extras: ["README.md", "LICENSE.txt"],
      main: "readme",
      homepage_url: @source_url,
      source_url: @source_url,
      source_url_pattern: "#{@source_url}/tree/v#{@version}/lib/%{file}#L%{line}",
      formatters: ["html"]
    ]
  end
end
