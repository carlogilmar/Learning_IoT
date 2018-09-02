defmodule ChatterWeb.RoomChannel do

  use ChatterWeb, :channel
  alias ChatterWeb.Presence
  alias Chatter.Director
  require Logger

  def join("room:lobby", _, socket) do
    Logger.info ":: Join to room:lobby ::", ansi_color: :green
    { _, current_user} = Director.suscribe()
    uart = Chatter.Uart.get_uart()
    Nerves.UART.write(uart, "1")
    send self(), :after_join
    {:ok, current_user, socket}
  end

  def send_message_from_terminal(body) do
    IO.puts " :: Broadcast :: << #{body} >> "
    ChatterWeb.Endpoint.broadcast "room:lobby", "message:new:client", %{body: body}
  end

  def send_broadcast( "play" ), do: send_message_from_terminal("start")
  def send_broadcast( "stop" ), do: send_message_from_terminal("stop")
  def send_broadcast( "49" ), do: send_message_from_terminal("A")
  def send_broadcast( "50" ), do: send_message_from_terminal("B")
  def send_broadcast( "51" ), do: send_message_from_terminal("C")
  def send_broadcast( "52" ), do: send_message_from_terminal("D")
  def send_broadcast( "53" ), do: send_message_from_terminal("E")
  def send_broadcast( "54" ), do: send_message_from_terminal("F")
  def send_broadcast( "55" ), do: send_message_from_terminal("G")
  def send_broadcast( "56" ), do: send_message_from_terminal("H")
  def send_broadcast( "65" ), do: send_message_from_terminal("start")
  def send_broadcast( "66" ), do: send_message_from_terminal("stop")
  def send_broadcast( "67" ), do: send_message_from_terminal("reload")
  def send_broadcast( _ ), do: IO.puts(" Monitoring UART! ")

end
