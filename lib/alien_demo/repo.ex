defmodule AlienDemo.Repo do
  use Ecto.Repo,
    otp_app: :alien_demo,
    adapter: Ecto.Adapters.Postgres
end
