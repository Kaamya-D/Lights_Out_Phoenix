defmodule LightsOut.Repo.Migrations.ChangeDefaultMinmoves do
  use Ecto.Migration

  def change do
    alter table(:users) do
      # Change the default value of minmoves to 9999
      modify :minmoves, :integer, default: 9999
    end
  end
end
