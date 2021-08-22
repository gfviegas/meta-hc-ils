import Config

config :logger, :console,
  metadata: [:mfa],
  utc_log: true
