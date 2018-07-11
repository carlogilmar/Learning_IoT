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

  def reg_changeset(struct, params) do
    struct
     |> changeset( params )
     |> cast(params, [:encrypt_pass])
     |> hash_pw()
  end

  defp hash_pw(changeset) do
    case changeset do
      %Ecto.Changeset{ valid?: true, changes: %{email: _, encrypt_pass: p}, errors: _, action: _, data: _} ->
        put_change( changeset, :encrypt_pass, Comeonin.Pbkdf2.hashpwsalt(p))
      _ ->
        changeset
    end
  end

end
