defmodule LightsOut.Repo.Migrations.AddMinmovesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
    add :minmoves, :integer, default: 0
    end
  end
end
