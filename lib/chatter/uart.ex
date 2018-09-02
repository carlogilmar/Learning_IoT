defmodule Chatter.Uart do

	use GenServer
  alias ChatterWeb.RoomChannel

	# Client
	def start_link() do
		GenServer.start_link(__MODULE__, [], [name: __MODULE__])
	end

	def get_uart( ) do
		GenServer.call( __MODULE__, :get_uart )
	end

  def read_uart() do
    GenServer.call( __MODULE__, :read_uart )
  end

	# Server
	def init(_) do
		IO.puts "== Getting uart pid"
		{:ok, uart_pid} = Nerves.UART.start_link
    IO.inspect uart_pid
		IO.puts "== Open port..."
		port = Nerves.UART.open( uart_pid, "ttyACM0", speed: 9600, active: false)
    Nerves.UART.configure(uart_pid, framing: {Nerves.UART.Framing.Line, separator: "\r\n"})
		IO.inspect port
    loop()
		{:ok, uart_pid}
	end

   defp loop() do
     send self(), :loop
   end

	def handle_call( :get_uart, _, state ) do
		# state is the uart_pid
		{:reply, state, state}
	end

  #def handle_call( :read_uart, _, state ) do
  #  pid = state
  #  {:ok, message_from_arduino} = Nerves.UART.read( pid, 60000 )
  #  RoomChannel.send_broadcast( message_from_arduino )
	#	{:reply, state, state}
  #end

  def handle_info(:loop, state) do
    {:ok, message_from_arduino} = Nerves.UART.read( state, 1000 )
    RoomChannel.send_broadcast( message_from_arduino )
    loop()
    {:noreply, state}
  end

end
