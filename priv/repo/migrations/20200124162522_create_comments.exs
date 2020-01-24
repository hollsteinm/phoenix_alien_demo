defmodule AlienDemo.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :title, :string
      add :content, :string
      add :submission_datetime, :utc_datetime

      timestamps()
    end

  end
end
