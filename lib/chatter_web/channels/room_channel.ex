defmodule ChatterWeb.RoomChannel do

  use ChatterWeb, :channel
  alias ChatterWeb.Presence
  require Logger

  def join("room:lobby", _, socket) do
    Logger.info ":: Join to room:lobby ::", ansi_color: :green
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    # socker.assigns is a map: %{user: "Carlo2 "}
    Logger.info ":: Updating Presence track with the new user ::"
    Presence.track( socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })

    presence_list = Presence.list(socket)
    IO.puts "================= after join =============="
    IO.inspect presence_list

    # presence_state lives in js app
    push socket, "presence_state", presence_list
    {:noreply , socket}
  end

  def handle_in("room::sync", message, socket) do
    IO.puts "Alguien vino o alguien se fue !!!"
    {:noreply, socket}
  end

  def handle_in("message:new", message, socket) do
    broadcast! socket, "message:new:client", %{
      user: socket.assigns.user,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }
    send_to_arduino( message )
    {:noreply, socket}
  end

  def send_to_arduino( message ) do
    IO.puts "Enviando al arduino..."
    uart = Chatter.Uart.get_uart()
    IO.inspect uart
    IO.puts "Enviando..."
    manage_led( message, uart )
  end

  def manage_led("1", pid) do
    IO.puts "Prende"
    Nerves.UART.write(pid, "1")
    :timer.sleep(500);
    IO.puts "Apaga"
    Nerves.UART.write(pid, "0")
    :timer.sleep(500);
    IO.puts "Prende"
    Nerves.UART.write(pid, "1")
    :timer.sleep(500);
    IO.puts "Apaga"
    Nerves.UART.write(pid, "0")
    :timer.sleep(500);
    IO.puts "Prende"
    Nerves.UART.write(pid, "1")
    :timer.sleep(500);
  end

  def manage_led(_, pid), do: Nerves.UART.write(pid, "0")

end
