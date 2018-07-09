defmodule ChatterWeb.UserController do

  use ChatterWeb, :controller

  alias Chatter.User
  alias Chatter.Repo

  def index(conn, _params) do
    # Getting all users from database
    users = Repo.all(User)
    # render a send a page with params
    render(conn, "index.html", users: users)
  end

end
