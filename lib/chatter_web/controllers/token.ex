defmodule ChatterWeb.Token do
  use ChatterWeb, :controller

  def unauthenticated(conn, _params) do
    conn
     |> put_flash(:error, "Por favor logueate")
     |> redirect(to: session_path( conn, :new ))
  end

  def unauthorized(conn, _params) do
    conn
     |> put_flash(:error, "Por favor logueate")
     |> redirect(to: session_path( conn, :new ))
  end
end
