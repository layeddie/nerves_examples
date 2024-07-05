defmodule HelloScenic.MixProject do
  use Mix.Project

  @app :hello_scenic
  @version "0.1.0"
  @all_targets [
    :rpi,
    :rpi0,
    :rpi2,
    :rpi3,
    :rpi3a,
    :rpi4,
    :bbb,
    :osd32mp1,
    :x86_64,
    :grisp2,
    :mangopi_mq_pro
  ]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.11",
      archives: [nerves_bootstrap: "~> 1.12.1"],
      # build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {HelloScenic, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.10", runtime: false},
      {:nerves_runtime, "~> 0.13.0"},
      {:ring_logger, "~> 0.11.0"},
      {:shoehorn, "~> 0.9.1"},
      {:scenic, "~> 0.11.2"},
      {:scenic_clock, "~> 0.11.0"},
      scenic_driver_local(),
      {:toolshed, "~> 0.4.0"},

      # Dependencies for all targets except :host
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi, "~> 1.13", runtime: false, targets: :rpi},
      {:nerves_system_rpi0, "~> 1.13", runtime: false, targets: :rpi0},
      {:nerves_system_rpi2, "~> 1.13", runtime: false, targets: :rpi2},
      {:nerves_system_rpi3, "~> 1.13", runtime: false, targets: :rpi3},
      {:nerves_system_rpi3a, "~> 1.13", runtime: false, targets: :rpi3a},
      {:nerves_system_rpi4, "~> 1.13", runtime: false, targets: :rpi4},
      {:nerves_system_bbb, "~> 2.8", runtime: false, targets: :bbb},
      {:nerves_system_osd32mp1, "~> 0.4", runtime: false, targets: :osd32mp1},
      {:nerves_system_x86_64, "~> 1.13", runtime: false, targets: :x86_64},
      {:nerves_system_grisp2, "~> 0.3", runtime: false, targets: :grisp2},
      {:nerves_system_mangopi_mq_pro, "~> 0.4", runtime: false, targets: :mangopi_mq_pro}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end

  defp scenic_driver_local do
    path = System.get_env("SCENIC_DRIVER_LOCAL_PATH", "")

    case File.exists?(path) do
      true ->
        {:scenic_driver_local, path: path}

      _ ->
        # Replace with hex.pm version when 0.12.0 is released
        {:scenic_driver_local, github: "ScenicFramework/scenic_driver_local", ref: "26cd49dee26bb5951e63e39b16840087c9b7d96f"}
    end
  end
end