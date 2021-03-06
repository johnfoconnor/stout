defmodule Stout.Mixfile do
  use Mix.Project

  def project do
    [app: :stout,
     version: "0.0.1",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [
      :lager
    ]]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
     {:conform, "~> 0.10.2"},
     {:lager, github: "basho/lager"}
    ]
  end
end
