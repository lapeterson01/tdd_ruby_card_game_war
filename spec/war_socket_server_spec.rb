require 'socket'
require_relative '../lib/war_socket_server'
require 'pry'

class MockWarSocketClient
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
    loop do
      sleep(0.1)
      break if @socket
    end
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
  end

  after(:each) do
    @server.stop
    @clients.each(&:close)
  end

  it 'is not listening on a port before it is started' do
    expect { MockWarSocketClient.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  it 'accepts new clients and starts a game if possible' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client
    @server.create_game_if_possible
    expect(@server.games.length).to eq 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client
    @server.create_game_if_possible
    expect(@server.games.length).to eq 1
  end

  it 'sends a message to be received by the client when client is connected' do
    @server.start
    client = MockWarSocketClient.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client
    expect(client.capture_output).to match(/You are connected!/)
  end

  it 'sends a message to client if no other player has joined yet' do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client
    expect(client1.capture_output).to match(/Waiting for another player/)
    client2 = MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client
    @clients << client1 << client2
    expect(client1.capture_output && client2.capture_output).to match(/Prepare to go to war!/)
  end
end
