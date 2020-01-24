defmodule AlienDemo.Repo.Migrations.CreateSaucers do
  use Ecto.Migration

  def change do
    create table(:saucers) do
      add :title, :string
      add :content, :string
      add :submission_datetime, :utc_datetime

      timestamps()
    end

  end
end
