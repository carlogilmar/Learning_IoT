defmodule Chatter.Uart do

	use GenServer

	# Client
	def start_link() do
		GenServer.start_link(__MODULE__, [], [name: __MODULE__])
	end

	def get_uart( ) do
		GenServer.call( __MODULE__, :get_uart )
	end

	# Server
	def init(_) do
		IO.puts "Getting uart pid"
		{:ok, uart_pid} = Nerves.UART.start_link
		IO.puts "Open port..."
		port = Nerves.UART.open( uart_pid, "ttyACM0", speed: 9600, active: false)
		IO.inspect port
		{:ok, uart_pid}
	end

	def handle_call( :get_uart, _, state ) do
		# state is the uart_pid
		{:reply, state, state}
	end

end
