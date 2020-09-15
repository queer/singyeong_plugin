defmodule SingyeongPlugin.MixProject do
  use Mix.Project

  @version "0.1.2"
  @repo_url "https://github.com/queer/singyeong_plugin"

  def project do
    [
      app: :singyeong_plugin,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      package: [
        maintainers: ["amy"],
        links: %{"GitHub" => @repo_url},
        licenses: ["MIT"],
      ],
      description: "Plugin API for singyeong.",

      # Docs
      name: "singyeong_plugin",
      docs: [
        homepage_url: "https://github.com/queer/singyeong",
        source_url: @repo_url,
        extras: [
          "README.md",
        ]
      ],
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:typed_struct, "~> 0.2.1"},
      {:plug, "~> 1.9"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end
end
