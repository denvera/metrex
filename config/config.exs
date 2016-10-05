# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :metrex,
  ttl: 3,
  counters: ["c_sample"],
  meters: ["m_sample"]
