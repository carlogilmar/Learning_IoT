defmodule Chatter.Uart do

	use GenServer

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

	def handle_call( :read_uart, _, state ) do
    {_, pid} = state
    IO.inspect state
    IO.puts "============"
    IO.inspect pid
    IO.puts " UART   R E A D I N G"
    sm = Nerves.UART.read( pid, 60000 )
    IO.inspect sm
		# state is the uart_pid
		{:reply, state, state}
  end

end
