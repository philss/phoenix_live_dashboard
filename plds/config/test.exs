import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :plds, PLDSWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
