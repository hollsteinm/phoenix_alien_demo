defmodule AlienDemo.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    field :submission_datetime, :utc_datetime
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:title, :content, :submission_datetime])
    |> validate_required([:title, :content, :submission_datetime])
  end
end
