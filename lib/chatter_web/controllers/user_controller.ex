defmodule ChatterWeb.UserController do

  use ChatterWeb, :controller

  alias Chatter.User
  alias Chatter.Repo
  require Logger

  # Show all users
  def index(conn, _params) do
    # Getting all users from database
    users = Repo.all(User)
    # render a send a page with params
    render(conn, "index.html", users: users)
  end

  def show( conn, %{"id" => id} ) do
    Logger.info ":: Show User ::", ansi_color: :red
    IO.inspect conn
    user = Repo.get!( User, id )
    IO.inspect user
    render(conn, "show.html", user: user)
  end

  # Create view
  def new(conn, _params) do
    Logger.info ":: Form for New User ::", ansi_color: :yellow
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  # Creating action
  def create(conn, %{"user" => user_params}) do
    Logger.info ":: Creating a new user ::", ansi_color: :yellow
    IO.inspect user_params
    changeset = User.changeset(%User{}, user_params)
    IO.inspect changeset
    repo_result = Repo.insert(changeset)
    case repo_result do
      {:ok, _user} ->
        conn
          |> put_flash(:info, "::: User Created successfully! :::")
          |> redirect(to: user_path(conn, :index) )
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # Update view
  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, %{})
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  # Updating action
  def update( conn, %{"id" => id, "user" => user_params }) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        conn
          |> put_flash(:info, "User Updated!")
          |> redirect(to: user_path(conn, :show, user) )
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  # Delete
  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    Repo.delete!(user)
    conn
      |> put_flash(:danger, "User #{id} deleted !")
      |> redirect(to: user_path(conn, :index) )
  end

end
