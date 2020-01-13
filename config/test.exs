use Mix.Config

# Configure your database
config :alien_demo, AlienDemo.Repo,
  username: "postgres",
  password: "postgres",
  database: "alien_demo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :alien_demo, AlienDemoWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
