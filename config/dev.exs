use Mix.Config

config :metrex,
  ttl: 900,
  counters: ["c_sample"],
  meters: ["m_sample"],
  hooks: Metrex.Hook.Default
