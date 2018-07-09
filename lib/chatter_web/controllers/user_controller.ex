defmodule ChatterWeb.UserController do

  use ChatterWeb, :controller

  alias Chatter.User
  alias Chatter.Repo
  require Logger

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

  def new(conn, _params) do
    Logger.info ":: New User ::", ansi_color: :yellow
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

end
