defmodule LightsOut.Repo do
  use Ecto.Repo,
    otp_app: :lights_out,
    adapter: Ecto.Adapters.Postgres
end
