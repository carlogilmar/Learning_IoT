defmodule ChatterWeb.RoomChannel do

  use ChatterWeb, :channel
  alias ChatterWeb.Presence
  alias Chatter.Director
  require Logger

  def join("room:lobby", _, socket) do
    Logger.info ":: Join to room:lobby ::", ansi_color: :green
    { _, current_user} = Director.suscribe()
    play_pacman_in_arduino()
    {:ok, current_user, socket}
  end

  def play_pacman_in_arduino() do
    uart = Chatter.Uart.get_uart()
    Nerves.UART.write(uart, "1")
  end

  def send_message_from_terminal(body) do
    IO.puts " :: Broadcast :: << #{body} >> "
    Logger.info ":: Sending Broadcast Message!! ::", ansi_color: :yellow
    ChatterWeb.Endpoint.broadcast "room:lobby", "message:new:client", %{body: body}
  end

  def send_broadcast( message ) do
    case message do
      "play" ->
        send_message_from_terminal("start")
      "stop" ->
        send_message_from_terminal("stop")
      "49" ->
        send_message_from_terminal("A")
      "50" ->
        send_message_from_terminal("B")
      "51" ->
        send_message_from_terminal("C")
      "52" ->
        send_message_from_terminal("D")
      "53" ->
        send_message_from_terminal("E")
      "54" ->
        send_message_from_terminal("F")
      "55" ->
        send_message_from_terminal("G")
      "56" ->
        send_message_from_terminal("H")
      "65" ->
        send_message_from_terminal("start")
      "66" ->
        send_message_from_terminal("play")
      "67" ->
        send_message_from_terminal("stop")
      "68" ->
        send_message_from_terminal("reload")
      _ ->
        Logger.info ":: Monitoring UART ::", ansi_color: :green
    end
  end

end
