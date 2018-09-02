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
    ChatterWeb.Endpoint.broadcast "room:lobby", "message:new:client", %{body: body}
  end

  def send_broadcast( _ ), do: IO.puts(" Monitoring! ")
  def send_broadcast( "play" ), do: IO.puts(" Play !")
  def send_broadcast( "stop" ), do: IO.puts(" stop ")
  def send_broadcast( "49" ), do: IO.puts(" song 1 ")
  def send_broadcast( "50" ), do: IO.puts(" song 2 ")
  def send_broadcast( "51" ), do: IO.puts(" song 3 ")
  def send_broadcast( "52" ), do: IO.puts(" song 4 ")
  def send_broadcast( "53" ), do: IO.puts(" song 5 ")
  def send_broadcast( "54" ), do: IO.puts(" song 6 ")
  def send_broadcast( "55" ), do: IO.puts(" song 7 ")
  def send_broadcast( "56" ), do: IO.puts(" song 8 ")
  def send_broadcast( "65" ), do: IO.puts(" play 2!! ")
  def send_broadcast( "66" ), do: IO.puts(" stop 2!! ")
  def send_broadcast( "67" ), do: IO.puts(" RELOAD!!")
  def send_broadcast( _ ), do: IO.puts(" Monitoring UART! ")

end
