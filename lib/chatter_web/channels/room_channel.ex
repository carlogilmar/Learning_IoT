defmodule ChatterWeb.RoomChannel do

  use ChatterWeb, :channel
  alias ChatterWeb.Presence
  require Logger

  def join("room:lobby", _, socket) do
    Logger.info ":: Join to room:lobby ::", ansi_color: :green
    IO.inspect socket
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Logger.info ":: New Connection Interaction ::", ansi_color: :green
    IO.inspect socket

    # socker.assigns is a map: %{user: "Carlo2 "}
    Logger.info ":: Updating Presence track with the new user ::"
    Presence.track( socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })

    presence_list = Presence.list(socket)
    IO.inspect presence_list

    # presence_state lives in js app
    push socket, "presence_state", presence_list
    {:noreply , socket}
  end

  def handle_in("message:new", message, socket) do
    broadcast! socket, "message:new:client", %{
      user: socket.assigns.user,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }
    {:noreply, socket}
  end

end
