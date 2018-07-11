defmodule ChatterWeb.SessionController do

  use ChatterWeb, :controller
  import Chatter.Auth
  alias Chatter.Repo

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{ "session" => %{ "email" => user, "password" => password } }) do
    case login_with( conn, user, password, repo: Repo) do
      {:ok, conn} ->
        logged_user = Guardian.Plug.current_resource(conn)
        conn
        |> put_flash(:info, "Bienvenido!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Datos no válidos")
        |> render("new.html")
    end
  end

end