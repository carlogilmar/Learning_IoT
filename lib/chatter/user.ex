defmodule Chatter.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :encrypt_pass, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :encrypt_pass])
    |> validate_required([:email, :encrypt_pass])
    |> unique_constraint(:email)
  end
end
