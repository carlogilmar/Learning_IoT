defmodule ChatterWeb.UserSocket do
  use Phoenix.Socket
  require Logger

  channel "room:*", ChatterWeb.RoomChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect( %{"user" => user} , socket) do
    conn = assign(socket, :user, user)
    Logger.info ":: Socket Connection for #{user}::", ansi_color: :green
    {:ok, conn}
  end

  def id(_socket), do: nil
end
