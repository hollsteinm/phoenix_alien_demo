defmodule AlienDemo.Saucer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "saucers" do
    field :content, :string
    field :submission_datetime, :utc_datetime
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(saucer, attrs) do
    saucer
    |> cast(attrs, [:title, :content, :submission_datetime])
    |> validate_required([:title, :content, :submission_datetime])
    |> validate_length(:title, min: 8, max: 24)
    |> validate_length(:content, min: 50, max: 256)
  end
end
