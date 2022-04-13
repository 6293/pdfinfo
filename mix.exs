defmodule Pdfinfo.MixProject do
  use Mix.Project

  def project do
    [
      app: :pdfinfo,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "pdfinfo wrapper"
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
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Yudai Kiyofuji"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/6293/pdfinfo"}
    ]
  end
end
